# Randomization

A set of `Julia` functions to simulate clinical trials targeting unequal allocation. 
So far, _eight different randomization procedures_ have been implemented.
There is a _simulation example_ comparing procedures in terms of

- _**Randomness**_
- _**Balance**_


## Notations

$K$ -- number of treatments ($K \geq 2$).

$w_1:\ldots:w_K$ -- fixed _allocation ratio_; $w_k$'s are positive, not necessarily equal integers with the greatest common divisor of 1.

$\rho_k = \frac{w_k}{\sum\limits_{k=1}^{K}{w_k}}$ -- target treatment allocation proportions; $0 \leq \rho_k \leq 1$, and $\sum\limits_{k=1}^K{\rho_k} = 1$.

$\boldsymbol{\rho} = \left(\rho_1, \ldots, \rho_K\right)$ -- vector of _target allocation proportions_.

$n$ -- total _sample size_ for the trial.

$\boldsymbol{N}(j) = \left(N_1(j), \ldots, N_K(j)\right)$ -- numbers of subjects assigned to $K$ treatments after $j$ allocations ($1 \leq j \leq n). Note that, in general, $N_k(j)$'s are are random variables with $\sum\limits_{k = 1}^K{N_k(j)} = j$.

$\boldsymbol{P}(j) = \left(P_1(j), \ldots, P_K(j)\right)$ -- vector of _treatment randomization probabilities_ for subject $j$.



