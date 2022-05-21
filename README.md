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

$\boldsymbol{N}(j) = \left(N_1(j), \ldots, N_K(j)\right)$ -- numbers of subjects assigned to $K$ treatments after $j$ allocations ($1 \leq j \leq n$). Note that, in general, $N_k(j)$'s are are random variables with $\sum\limits_{k = 1}^K{N_k(j)} = j$.

$\boldsymbol{P}(j) = \left(P_1(j), \ldots, P_K(j)\right)$ -- vector of _treatment randomization probabilities_ for subject $j$. Note that $0 \leq P_k(j) \leq 1$, and $\sum\limits_{k = 1}^K{P_k(j)} = 1$ for every $j = 1, 2, \ldots, n$. Also, note that in general, $\boldsymbol{P}(j)$ depends on $\boldsymbol{N}(j-1)$ (in generalization of Efron's BCD) or on $\frac{\boldsymbol{N}(j-1)}{j-1}$ (in generalization of Wei's UD).

## Currently implemented procedures

i) **C**ompletely **R**andomized **D**esign (_**CRD**_): Every subject is randomizad to treatment group with fixed probabilities that are equal to the target allocation proportions:

$$
P_k(j) = \rho_k, \quad k= 1, \ldots, K.
$$

ii) **P**ermuted **B**lock **D**esign (_**PBD**_($\lambda$)): Let $W = w_1 + w_2 + \ldots + w_K$, and let $b = \lambda W$, where $\lambda$="_number of minimal balanced sets in the block of size_ $b$". Let $k^{(j-1)} = int\left(\frac{j-1}{b}\right)$ ($int(x)$ returns the greatest integer less than or equal to $x$). In essence, it is the number of complete blocks among the first $j−1$ assignments. The conditional randomization probability for the _**PBD**_ design is given by [Zhao and Weng (2011), page 955, equation (5)]:

$$
P_k(j) = \frac{w_k\lambda(1 + k^{(j-1)})-N_k(j-1)}{b(1 + k^{(j-1)})-(j-1)}, \quad k = 1, \ldots, K.
$$

iii) **B**lock **U**rn **D**esign (_**BUD**_($\lambda$)): This design was proposed by Zhao and Weng (2011), to provide a more random design than the 
_**PBD**_($\lambda$). Let $N_k(j-1)$ denote the number of treatment $K$ assignments among first $j−1$ subjects, and $k^{(j-1)} = \left\{int\left(\frac{N_k(j-1)}{w_k}\right)\right\}$ denote the number of minimal balanced sets among the first $j−1$ assignments.
