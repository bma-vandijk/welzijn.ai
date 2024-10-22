import datasets
import torch
import torch.nn as nn
from torch.autograd import Variable
from transformers import (
    AutoTokenizer,
    AutoModel,
    get_scheduler,
    get_constant_schedule_with_warmup,
)
from torch.utils.data import Dataset, DataLoader
from torch.cuda.amp import autocast, GradScaler
import tqdm
import numpy
import math
import matplotlib.pyplot as plt
from IPython import display
import random
import sys
from ModifiedDataLoader import loader
from TrainerUtils import predict
import InitNetwork

import argparse

DEVICE = torch.device("cuda" if torch.cuda.is_available() else "cpu")
print(DEVICE)


def parse_opt():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--encoder",
        type=str,
        default="xlm-roberta-large",
        help="model type(name in transformers)",
    )
    parser.add_argument(
        "--encoder_lr",
        type=float,
        default="1e-5",
        help="learning rate of encoder network",
    )
    parser.add_argument(
        "--head_lr",
        type=float,
        default="1e-3",
        help="learning rate of head network (for fuser/reasoning network)",
    )
    parser.add_argument(
        "--sample_count", type=int, default="1", help="counts of sampling in one batch"
    )
    parser.add_argument(
        "--entry_count",
        type=int,
        default="16",
        help="number of entries in each sampling",
    )
    parser.add_argument("--epoch", type=int, default="7", help="number of epochs")
    parser.add_argument(
        "--datasets",
        nargs="+",
        type=str,
        default=["ChatTest"],
        help="involved datasets",
    )
    parser.add_argument(
        "--warmups", type=float, default="0.16", help="proportion of warming up iters"
    )
    parser.add_argument(
        "--evaluation_only", type=bool, default=True, help="evaluation only"
    )
    parser.add_argument(
        "--weights",
        type=str,
        default="Models/xlmr_params.pkl",
        help="path of trained model weights",
    )

    opt = parser.parse_args(args=[])

    # print(vars(opt))

    return opt


def get_model():
    opt = parse_opt()
    DEVICE = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    BIDIRECTION = True
    NEW_TOKENS = ["<P>", "</P>", "<Q>", "</Q>", "<O>", "</O>"]
    BATCH_SIZE = opt.entry_count
    ACCUMULATION_ITER = opt.sample_count
    FT_LEARNING_RATE = opt.encoder_lr
    LEARNING_RATE = opt.head_lr
    EPOCH = opt.epoch
    WARMUPS = opt.warmups
    NAME_DATASETS = opt.datasets

    print("loading model weights from huggingface")
    TOKENIZER = AutoTokenizer.from_pretrained(opt.encoder)
    ENCODER = AutoModel.from_pretrained(opt.encoder)
    HIDDEN = ENCODER.embeddings.word_embeddings.embedding_dim
    model = InitNetwork.FCC_Network(
        TOKENIZER, ENCODER, BATCH_SIZE, HIDDEN, NEW_TOKENS, fuse=True, fuser_depth=3
    )
    print("loading model weights from huggingface")
    # state_dict = torch.load(opt.weights)
    # state_dict.pop("encoder.embeddings.position_ids", None)
    # model.load_state_dict(torch.load(opt.weights))
    new_state_dict = torch.load(opt.weights, map_location=DEVICE)
    del new_state_dict["encoder.embeddings.position_ids"]
    model.load_state_dict(new_state_dict)
    model.to(DEVICE)
    return model, opt


def main(opt, model, chat, question, options):
    DEVICE = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    BIDIRECTION = True
    NEW_TOKENS = ["<P>", "</P>", "<Q>", "</Q>", "<O>", "</O>"]
    BATCH_SIZE = opt.entry_count
    ACCUMULATION_ITER = opt.sample_count
    FT_LEARNING_RATE = opt.encoder_lr
    LEARNING_RATE = opt.head_lr
    EPOCH = opt.epoch
    WARMUPS = opt.warmups
    NAME_DATASETS = opt.datasets
    datasets = []
    for name in NAME_DATASETS:
        datasets.append(loader(name, BATCH_SIZE, NEW_TOKENS, chat, question, options))

    prediction = []
    for dataset in datasets:
        prediction = predict(DEVICE, model, dataset, BIDIRECTION)
    return prediction[0]


def Scale(model, opt, chat, question, options):
    pred = main(opt, model, chat, question, options)
    return pred
