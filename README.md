# Restricted randomization procedures

A set of `Julia` functions to simulate _multi-arm_ clinical trials targeting _unequal allocation_. 
So far, _eight different randomization procedures_ have been implemented.
There is a _simulation example_ comparing procedures in terms of _**Balance-Randomness trade-off**_.


## Notations

$K$ -- number of treatments ($K \geq 2$).

$w_1:\ldots:w_K$ -- fixed _allocation ratio_; $w_k$'s are positive, not necessarily equal integers with the greatest common divisor of 1.

$\rho_k = \frac{w_k}{\sum\limits_{k=1}^{K}{w_k}}$ -- target treatment allocation proportions; $0 \leq \rho_k \leq 1$, and $\sum\limits_{k=1}^K{\rho_k} = 1$.

$\boldsymbol{\rho} = \left(\rho_1, \ldots, \rho_K\right)$ -- vector of _target allocation proportions_.

$n$ -- total _sample size_ for the trial.

$\boldsymbol{N}(j) = \left(N_1(j), \ldots, N_K(j)\right)$ -- numbers of subjects assigned to $K$ treatments after $j$ allocations ($1 \leq j \leq n$). Note that, in general, $N_k(j)$'s are are random variables with $\sum\limits_{k = 1}^K{N_k(j)} = j$.

$\boldsymbol{P}(j) = \left(P_1(j), \ldots, P_K(j)\right)$ -- vector of _treatment randomization probabilities_ for subject $j$. Note that $0 \leq P_k(j) \leq 1$, and $\sum\limits_{k = 1}^K{P_k(j)} = 1$ for every $j = 1, 2, \ldots, n$. Also, note that in general, $\boldsymbol{P}(j)$ depends on $\boldsymbol{N}(j-1)$ (in generalization of Efron's BCD) or on $\frac{\boldsymbol{N}(j-1)}{j-1}$ (in generalization of Wei's UD).

## Implemented procedures

i) **C**ompletely **R**andomized **D**esign (_**CRD**_): Every subject is randomizad to treatment group with fixed probabilities that are equal to the target allocation proportions:

$$
P_k(j) = \rho_k, \quad k= 1, \ldots, K.
$$

ii) **P**ermuted **B**lock **D**esign (_**PBD**_($\lambda$)): Let $W = w_1 + w_2 + \ldots + w_K$, and let $b = \lambda W$, where $\lambda$="_number of minimal balanced sets in the block of size_ $b$". Let $k^{(j-1)} = int\left(\frac{j-1}{b}\right)$ ($int(x)$ returns the greatest integer less than or equal to $x$). In essence, it is the number of complete blocks among the first $j???1$ assignments. The conditional randomization probability for the _**PBD**_ design is given by [Zhao and Weng (2011), page 955, equation (5)]:

$$
P_k(j) = \frac{w_k\lambda(1 + k^{(j-1)})-N_k(j-1)}{b(1 + k^{(j-1)})-(j-1)}, \quad k = 1, \ldots, K.
$$

iii) **B**lock **U**rn **D**esign (_**BUD**_($\lambda$)): This design was proposed by Zhao and Weng (2011), to provide a more random design than the 
_**PBD**_($\lambda$). Let $N_k(j-1)$ denote the number of treatment $K$ assignments among first $j???1$ subjects, and $k^{(j-1)} = \min\limits_{1\leq k \leq K}\left[int\left(\frac{N_k(j-1)}{w_k}\right)\right]$ denote the number of minimal balanced sets among the first $j???1$ assignments. Then subject $j$ is randomized to treatments with probabilities [Zhao and Weng (2011), page 955, equation (2)]:

$$
P_k(j) = \frac{w_k(\lambda + k^{(j-1)})-N_k(j-1)}{W(\lambda + k^{(j-1)})-(j-1)}, \quad k = 1, \ldots, K.
$$

iv) **M**ass **W**eighted **U**rn **D**esign (_**MWUD**_($\alpha$)): This design was proposed by Zhao (2015). The parameter $\alpha>0$ controls the maximum tolerated treatment imbalance. In his paper, Zhao (2015) considered 4 choices: $\alpha$ = 2; 4; 6; 8. _**MWUD**_($\alpha$) has the following formula for (conditional) treatment allocation probabilities [Zhao (2015), page 211, equation (7a)]:

$$
P_k(j) = \frac{\max\left(\alpha\rho_k - N_k(j-1)+(j-1)\rho_k, 0\right)}{\sum\limits_{k = 1}^K{\max\left(\alpha\rho_k - N_k(j-1)+(j-1)\rho_k, 0\right)}}, \quad k = 1, \ldots, K.
$$

v) **D**rop-the-**L**oser Rule (_**DL**_($a$)): The _**DL**_ rule was developed by Ivanova (2003) in the context of multi-arm binary response trials with response-adaptive randomization. Here we consider its application for fixed unequal allocation. Consider an urn containing balls of $K+1$ types: types $1, 2, \ldots, K$ represent treatments, and type $0$ is the immigration ball. Initially, the urn contains 1 immigration ball and $w_k$ treatment balls. The treatment assignments are made sequentially by drawing balls at random from the urn. If a type $k$ ball is drawn ($k=1, 2, \ldots, K$), treatment $k$ is assigned to the subject, and the ball is not replaced into the urn. If type $0$ ball is drawn, it is replaced into the urn along with $aw_1, aw_2, \ldots, aw_K$ balls of types $1, 2, \ldots, K$. The parameter $a$ is some positive integer (larger values of $a$ imply greater amount of randomness in the experiment). The _**DL**_ rule is a fully randomized procedure, and it is known to be asymptotically best (Hu et al. 2006).

vi) **D**oubly-**A**daptive **B**iased **C**oin **D**esign (_**DBCD**_($\gamma$)): The _**DBCD**_ design was developed by Hu and Zhang (2004) in the context of response-adaptive randomization. Here we consider its application for fixed unequal allocation. Initial treatment assignments ($j=1, 2, \ldots, m_0$) are made completely at random ($P_k(j) = \rho_k$) until each group has at least one subject (i.e., $N_k(m_0)>0$, $k=1, 2, \ldots, K$). Subsequent treatment assignments are made as follows:

$$
P_k(j) = \frac{\rho_k\left(\rho_k/\frac{N_k(j-1)}{j-1}\right)^\gamma}{\sum\limits_{k=1}^K \rho_k\left(\rho_k/\frac{N_k(j-1)}{j-1}\right)^\gamma}, \quad k = 1, \ldots, K.
$$

vii) **Min**imum **Q**uadratic **D**istance Constrained Balance Randomization (_**MinQD**_($\eta$)): The design was proposed by Titterington (1983), in the context of multi-arm randomized trials with covariate-adaptive randomization and balanced allocation. Here we consider an extension of this procedure to clinical trials with unequal allocation.

Consider a point in the trial when $j???1$ subjects have been randomized among the $K$ treatments, and let denote the corresponding treatment numbers $\left(\sum\limits_{k=1}^K{N_k(j-1)} = j-1\right)$. The randomization rule for the $j^\text{th}$ subject is as follows:

  a) For $k=1, 2, \ldots, K$, compute $B_k$, the hypothetical "lack of balance" which results from assigning the $j^\text{th}$ subject to treatment $K$: $B_k = \max\limits_{1\leq i \leq K}\left|\frac{N^{(k)}_i(j)}{j}-\rho_k\right|$, where
  
$$
N_i^{(k)}(j) = \left[
\begin{array}{rl}
N_i(j-1) + 1, & i = k \\
N_i(j-1), & i \ne k
\end{array}
\right.
$$

  b) The treatment randomization probabilities for the $j^\text{th}$ subject ($P_1(j), P_2(j), \ldots, P_K(j)$) are determined as a solution to the constrained optimization problem:
  
$$
\begin{array}{l}
\text{minimize} \sum\limits_{k=1}^K\left(P_k(j)-\rho_k\right)^2 \\
\text{subject to } \sum\limits_{k=1}^KB_kP_k(j) \leq \eta B_{(1)} + (1-\eta)\sum\limits_{k=1}^KB_k\rho_k \\
\text{and }\sum\limits_{k=1}^KP_k(j) = 1; \quad 0 \leq P_k(j) \leq 1, \quad k = 1, 2, \ldots K,
\end{array}
$$

where $\eta$ is the user-defined parameter ($0 \leq \eta \leq 1$) that controls degree of randomness ($\eta=0$ is the most random, and $\eta=1$
is almost deterministic procedure).

viii) **Max**imum **Ent**ropy Constraint Balance Randomization (_**MaxEnt**_($\eta$)): The design was proposed by Klotz (1978), in the context of multi-arm randomized trials with covariate-adaptive randomization and balanced allocation. Here we consider an extension of this procedure to clinical trials with unequal allocation. 

The _**MaxEnt**_ design follows the same idea as the _**MinQD**_($\eta$) design, except for step (b), in which the constrained optimization problem deals with minimization of the _Kullback-Leibler divergence_ between ($P_1(j), P_2(j), \ldots, P_k(j)$) and ($\rho_1, \rho_2, \ldots, \rho_K$):

$$
\begin{array}{l}
\text{minimize} \sum\limits_{k=1}^KP_k(j)\log\left(\frac{P_k(j)}{\rho_k}\right) \\
\text{subject to } \sum\limits_{k=1}^KB_kP_k(j) \leq \eta B_{(1)} + (1-\eta)\sum\limits_{k=1}^KB_k\rho_k \\
\text{and }\sum\limits_{k=1}^KP_k(j) = 1; \quad 0 \leq P_k(j) \leq 1, \quad k = 1, 2, \ldots K,
\end{array}
$$

where $0 \leq \eta \leq 1$ controls degree of randomness of the procedure.

## Operational characteristics

### Balance

For a design with $n$ subjects, treatment imbalance can be defined as a distance, in some metric, between the achieved allocation $(N_1(n), \ldots, N_K(n))$ and the target allocation $(n\rho_1, \ldots, n\rho_K)$. Using Euclidean metric, the imbalance is defined as

$$
Imb(n) = \sqrt{\sum\limits_{k=1}^K\left(N_k(n)-n\rho_k\right)^2}.
$$

For procedures that have the center of the probability mass at the point of perfect balance for every $n$, this measure can be interpreted as the momentum of probability mass (MPM). Thus, for any allocation step $j$, one can calculate

$$
MPM(j) = \mathbf{E}\left[Imb(j)\right], \quad j = 1, 2, \ldots, n.
$$

Small values of MPM are desirable throughout the course of the trial.

### Randomness

Forcing index ($FI$) is considered as a measure of lack of randomness. For the $j^\text{th}$ subject, the $FI$ is the distance from the vector of conditional randomization probabilities $P(j) = \left(P_1(j),\ldots, P_K(j)\right)$ and the vector of target randomization probabilities 
$?? = \left(\rho_1,\ldots, \rho_K\right)$:

$$
FI_j = \sqrt{\sum\limits_{k=1}^K\left(P_k(j)-\rho_k\right)^2}.
$$

If $FI_j = 0$, then the treatment assignment for the  $j^\text{th}$ subject is made completely at random. Then the $FI$ for the design is obtained as

$$
FI(n) = \frac{1}{n}\sum\limits_{j = 1}^n{FI_j}.
$$

The smaller the $FI(n)$ is, the less predictable the randomization procedure is; the value of $FI(n) = 0$ corresponds to the _**CRD**_ procedure. As with the imbalance, it is important to study not only the final $FI$ after $n$ subjects but also its intermediate values, i. e., $FI(j)$, $1 \leq j \leq n$.
