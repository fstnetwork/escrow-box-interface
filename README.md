# escrow-box-interface

## States

1. OPEN
2. PROPOSING
3. NEGOTIATING
4. CANCELLING
5. FINALISING

## Actions

1. PROPOSE
2. NEGOTIATE
3. CANCEL
4. FINALISE

## How to implement

Please refer to the `transferAndCall` section in [ERC-1376](https://github.com/fstnetwork/EIPs/blob/master/EIPS/eip-1376.md) first, and design in what conditions that users can do the actions and push the state into next one.

Before the FINALISING state, other states must have expiry to avoid the eternal resource locking (e.g. ETH / Tokens).

```
    
[OPEN] -(anyone proposes)-→ [PROPOSING] ---------------(passes the proposal conditions)-------------→ [NEGOTIATING] --(passes the negotiation conditions)-→ [FINALISING]
  ↑                              |                                                                           |                                                   |
   \                             \-(anyone cancels or expired)-→  [CANCELLING] ←-(anyone cancels or expired)-/                                                   |
    \-------------------------------------------------------------------/                                                                                        |
     \-----------------------------------------------------------(finalise)--------------------------------------------------------------------------------------/
```
