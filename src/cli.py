#!/usr/bin/env python3
import subprocess
import sys
from pathlib import Path

from rich import print

from src.parsers import default_model_parser
from src.parsers import low_parser
from src.parsers import preproc_parser
from src.parsers import stats_parser


def low(argv=sys.argv) -> None:

    parser = low_parser()

    args = parser.parse_args(argv[1:])


def default_model(argv=sys.argv) -> None:

    parser = default_model_parser()

    args = parser.parse_args(argv[1:])

    bids_dir = Path(args.bids_dir[0]).resolve()
    output_dir = Path(args.output_dir[0]).resolve()

    task = None
    if args.task:
        task = "{ '" + "', '".join(args.task) + "' }"

    space = None
    if args.space:
        space = "{ '" + "', '".join(args.space) + "' }"

    octave_cmd = f"bidspm(); bidspm('{bids_dir}', '{output_dir}', 'dataset', 'action', 'default_model'"

    if space:
        octave_cmd += f", 'space', {space}"

    if task:
        octave_cmd += f", 'task', {task}"

    octave_cmd += "); exit;"

    print("Running the following command:")
    print(octave_cmd)
    print()

    subprocess.run(
        [
            "octave",
            "--no-gui",
            "--no-window-system",
            "--silent",
            "--eval",
            f"{octave_cmd}; exit;",
        ]
    )


def stats(argv=sys.argv) -> None:

    parser = stats_parser()

    args = parser.parse_args(argv[1:])

    bids_dir = Path(args.bids_dir[0]).resolve()
    output_dir = Path(args.output_dir[0]).resolve()
    action = args.action
    preproc_dir = Path(args.preproc_dir[0]).resolve()
    model_file = Path(args.model_file[0]).resolve()

    octave_cmd = "bidspm()"

    subprocess.run(
        [
            "octave",
            "--no-gui",
            "--no-window-system",
            "--silent",
            "--eval",
            f"{octave_cmd}; exit;",
        ]
    )


def preproc(argv=sys.argv) -> None:

    parser = preproc_parser()

    args = parser.parse_args(argv[1:])


def main(argv=sys.argv) -> None:

    parser = preproc_parser()

    args = parser.parse_args(argv[1:])


if __name__ == "__main__":
    main()
