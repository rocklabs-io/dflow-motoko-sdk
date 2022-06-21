import Result "mo:base/Result";

module {
    public type FlowType = {
        #Constant;
    };
    public type Flow = {
        id : Text;
        startTime : Nat64;
        deposit : Nat;
        sender : Principal;
        flowRate : Nat;
        flowType : FlowType;
        settleFunds : Nat;
        receiver : Principal;
        settleTime : Nat64;
    };

    public type InitArgs = {
        cap : ?Principal;
        fee : Nat;
        decimals : Nat8;
        owner : ?Principal;
        logo : Text;
        name : Text;
        underlyingToken : ?Principal;
        symbol : Text;
    };

    public type Metadata = {
        fee : Nat;
        decimals : Nat8;
        owner : Principal;
        logo : Text;
        name : Text;
        totalSupply : Nat;
        symbol : Text;
    };
    public type TxReceipt = { #Ok : Nat; #Err : TxError };
    public type TxError = {
        #InsufficientAllowance;
        #InsufficientBalance;
        #ErrorOperationStyle;
        #Unauthorized;
        #LedgerTrap;
        #ErrorTo;
        #Other : Text;
        #BlockUsed;
        #AmountTooSmall;
    };
    public type UserFlowsResponse = {
        receiveFlows : [Flow];
        sendFlows : [Flow];
    };
    public type UserInfoResponse = {
        balance : Nat;
        receiveFlows : [Flow];
        liquidationDate : Nat64;
        flowRate : Int;
        sendFlows : [Flow];
    };
    public type DToken = actor {
        addApp : shared(app: Principal) -> async TxReceipt;
        addAuth : shared(user: Principal) -> async TxReceipt;
        addOperator : shared(op: Principal) -> async TxReceipt;
        allowance : (owner: Principal, spender: Principal) -> async Nat;
        approve : shared(spender: Principal, value: Nat) -> async TxReceipt;
        balanceOf : (user: Principal) -> async Nat;
        burn : shared(user: Principal, value: Nat) -> async TxReceipt;
        createFlow : shared(flowType: FlowType, sender: Principal, receiver: Principal, flowRate: Nat) -> async Result.Result<Text, TxError>;
        deleteFlow : shared(id: Text) -> async TxReceipt;
        getApps : () -> async [Principal];
        getFlow : (id: Text) -> async ?Flow;
        getLiquidationUser : () -> async [Principal];
        getMetadata : () -> async [Metadata];
        getUnderlyingToken : () -> async ?Principal;
        getUserFlowRate : (user: Principal) -> async Int;
        getUserFlows : (user: Principal) -> async UserFlowsResponse;
        getUserInfo : (user: Principal) -> async UserInfoResponse;
        getUserLiquidationDate : (user: Principal) -> async Nat64;
        isOperator : (owner: Principal, spender: Principal) -> async Bool;
        liquidateUser : shared(user: Principal) -> async TxReceipt;
        mint : shared(user: Principal, value: Nat) -> async TxReceipt;
        removeApp : shared(app: Principal) -> async TxReceipt;
        removeAuth : shared(user: Principal) -> async TxReceipt;
        removeOperator : shared(user: Principal) -> async TxReceipt;
        setUnderlyingToken : shared(token: ?Principal) -> async ();
        transfer : shared(to: Principal, value: Nat) -> async TxReceipt;
        transferFrom : shared(from: Principal, to: Principal, value: Nat) -> async TxReceipt;
        updateFlow : shared(id: Text, flowRate: Nat) -> async TxReceipt;
    };
}
