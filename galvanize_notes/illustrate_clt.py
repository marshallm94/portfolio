import math as m
import numpy as np
import scipy.stats as stats
import matplotlib.pyplot as plt
from random import choices

def plot_means(d, params, fig, ax, repeat, size=200):

    result = None
    means = []

    for i in range(repeat):

        if d == 'Poisson':
            result = stats.poisson(**params).rvs(size)
            means.append(result.mean())
        elif d == 'Binomial':
            result = stats.binom(**params).rvs(size)
            means.append(result.mean())
        elif d == 'Exponential':
            result = stats.expon(**params).rvs(size)
            means.append(result.mean())
        elif d == 'Geometric':
            result = stats.geom(**params).rvs(size)
            means.append(result.mean())
        elif d == 'Uniform':
            result = stats.uniform(**params).rvs(size)
            means.append(result.mean())

    ax = fig.add_subplot(ax[0],ax[1],ax[2])
    ax.hist(means, bins=100)
    ax.set_title(f"{d}-repeat:{repeat}-size:{size}")


def illustrate_clt(dist, params, repeat, size=200):
    fig = plt.figure(figsize=(16,12))
    total = len(repeat)
    dim = m.floor(m.sqrt(total))
    for x, i in enumerate(repeat):
        axes = [(dim, dim, x + 1) for j in range(total)]
        plot_means(dist, params, fig=fig, ax=axes[x], repeat=i, size=size)
    plt.tight_layout()
    plt.show()


if __name__ == '__main__':

    poisson = {'mu': 4.5}
    binom = {'n': 56, 'p': 0.5}
    expon = {'loc': 4.5, 'scale': 1}
    geo = {'p': 0.5}
    uni = {'loc':50, 'scale':150}

    repeats = [100,500,750,1000,1250,1500,2000,3000,5000]

    illustrate_clt('Poisson', poisson, repeats, size=50)
    illustrate_clt('Binomial', binom, repeats, size=50)
    illustrate_clt('Exponential', expon, repeats, size=50)
    illustrate_clt('Geometric', geo, repeats, size=50)
    illustrate_clt('Uniform', uni, repeats, size=50)
