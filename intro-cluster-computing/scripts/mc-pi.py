"""Practical plain parallel Python program"""

from argparse import ArgumentParser
from multiprocessing import Pool
import random
from functools import partial


NTRIALS = 100_000_000


def mc_circle_area(ntrials: int = NTRIALS, radius: int = 1) -> float:
    """
    Estimate the area of a circle of given radius using Monte Carlo simulation.

    """
    inside_circle = 0

    random.seed()
    radius_sq = radius * radius
    # Slow Python loop
    for _ in range(ntrials):
        x = random.uniform(-radius, radius)
        y = random.uniform(-radius, radius)
        if x * x + y * y <= radius_sq:
            inside_circle += 1

    return inside_circle / ntrials * 4


def main():
    parser = ArgumentParser()
    parser.add_argument("n", type=int, help="Number of parallel processes to run")
    parser.add_argument(
        "--ntrials",
        type=int,
        default=NTRIALS,
        help="Number of trials for each calculation",
    )
    parser.add_argument("--radius", type=float, default=1, help="Base circle radius")
    args = parser.parse_args()

    func = partial(mc_circle_area, ntrials=args.ntrials, radius=args.radius)
    with Pool(processes=args.n) as pool:
        jobs = [pool.apply_async(func) for _ in range(args.n)]
        results = [job.get() for job in jobs]
    print(sum(results) / len(results))


if __name__ == "__main__":
    main()
