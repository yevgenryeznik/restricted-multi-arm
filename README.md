# Randomization

A set of `Julia` functions to simulate clinical trials targeting unequal allocation. 
So far, _eight different randomization procedures_ have been implemented.
There is a _simulation example_ comparing procedures in terms of

- _**Randomness**_
- _**Balance**_


## Notations

$K$ -- number of treatments ($K \geq 2$).

$w_1:\ldots:w_K$ -- fixed allocation ratio; $w_k$'s are positive, not necessarily equal integers with the greatest common divisor of 1.

$\rho_k = \frac{w_k}{\sum\limits_{k=1}^{K}{w_k}}$ -- target treatment allocation proportions; $0 \leq \rho_k \leq 1$, and $\sum\limits_{k=1}^K{\rho_k} = 1$.


