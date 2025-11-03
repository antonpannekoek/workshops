"""Practical plain parallel Python program"""

from argparse import ArgumentParser
from multiprocessing import Pool
import random
from functools import partial


NTRIALS = 100_000_000


def mc_circle_area(radius: int, ntrials: int = NTRIALS) -> float:
    """
    Estimate the area of a circle of given radius using Monte Carlo simulation.

    """
    inside_circle = 0

    for _ in range(ntrials):
        x = random.uniform(-radius, radius)
        y = random.uniform(-radius, radius)
        if x*x + y*y <= radius*radius:
            inside_circle += 1

    square_area = (2 * radius) ** 2
    return (inside_circle / ntrials) * square_area


def main():
    parser = ArgumentParser()
    parser.add_argument("n", type=int, help="Number of parallel processes to run")
    parser.add_argument("--ntrials", type=int, default=NTRIALS, help="Number of trials for each calculation")
    parser.add_argument("--radius", type=float, default=1, help="Base circle radius")
    parser.add_argument("--repeat", type=int, default=1, help="Number of runs")
    args = parser.parse_args()


    radii = [args.radius * i for i in range(1, args.n+1)]    
    func = partial(mc_circle_area, ntrials=args.ntrials)
    for i in range(args.repeat):
        with Pool(processes=args.n) as pool:
            results = pool.map(func, radii)
        print(results)


if __name__ == "__main__":
    main()
