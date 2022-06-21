## DFlow Motoko SDK

In this repo we provide the [DFlow Motoko SDK](./src/dflow.mo) and an [example App](./src/app.mo) to showcase how to integrate DFlow into your application.

The receiving canister must implement the following 4 functions to handle money flow event updates:
```
onFlowCreation: (args: Flow) -> ();
onFlowUpdate: (args: Flow) -> ();
onFlowDeletion: (args: Flow) -> ();
onFlowLiquidation: (args: Flow) -> ();
```
