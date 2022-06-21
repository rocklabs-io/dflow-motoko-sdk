import TrieSet "mo:base/TrieSet";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import Error "mo:base/Error";
import Principal "mo:base/Principal";
import Option "mo:base/Option";
import Cycles "mo:base/ExperimentalCycles";
import Nat8 "mo:base/Nat8";
import Result "mo:base/Result";
import Prelude "mo:base/Prelude";
import DFlow "./dflow";

shared(msg) actor class ExampleApp(owner_: Principal) = this {

    private stable var owner: Principal = owner_;
    // the token used for subscription fee(test dUSDC)
    private stable var feeTokenId: Principal = Principal.fromText("m65t2-zyaaa-aaaah-qc2ua-cai");
    private stable var feeToken: DFlow.DToken = actor(Principal.toText(feeTokenId));
    // assume subscription fee is 3600 unit dUSDC/hour, i.e. flowRate = 1 unit dUSDC/second
    private stable var minFlowRate: Nat = 1;

    // record subscribed users
    private stable var users = TrieSet.empty<Principal>();

    // the service provided by the App
    public shared(msg) func service(): async Result.Result<Text, Text> {
        // check if msg.caller in the subscription set
        if(TrieSet.mem(users, msg.caller, Principal.hash(msg.caller), Principal.equal) == false) {
            return #ok("hello world");
        } else {
            return #err("not a subscribed user!");
        };
    };

    public query func getSubscribedUsers(): async TrieSet.Set<Principal> {
        users
    };

    // service owner can withdraw fees
    public shared(msg) func withdrawFees(amount: Nat): async DFlow.TxReceipt {
        assert(msg.caller == owner);
        await feeToken.transfer(msg.caller, amount)
    };

    public shared(msg) func onFlowCreation(flow: DFlow.Flow) : async () {
        // check caller
        assert(msg.caller == feeTokenId);
        // check flow rate, if valid, put flow sender to subscribed set
        if(flow.flowRate >= minFlowRate) {
            users := TrieSet.put(users, flow.sender, Principal.hash(flow.sender), Principal.equal);
        };
    };

    public shared(msg) func onFlowUpdate(flow: DFlow.Flow) : async () {
        // check caller
        assert(msg.caller == feeTokenId);
        // check flow rate, if valid, put flow sender to subscribed set; if not, remove user
        if(flow.flowRate >= minFlowRate) {
            users := TrieSet.put(users, flow.sender, Principal.hash(flow.sender), Principal.equal);
        } else {
            users := TrieSet.delete(users, flow.sender, Principal.hash(flow.sender), Principal.equal);
        };
    };

    public shared(msg) func onFlowDeletion(flow: DFlow.Flow) : async () {
        // check caller
        assert(msg.caller == feeTokenId);
        users := TrieSet.delete(users, flow.sender, Principal.hash(flow.sender), Principal.equal);
    };

    public shared(msg) func onFlowLiquidation(flow: DFlow.Flow) : async () {
        // check caller
        assert(msg.caller == feeTokenId);
        users := TrieSet.delete(users, flow.sender, Principal.hash(flow.sender), Principal.equal);
    };
}
