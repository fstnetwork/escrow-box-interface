pragma solidity ^0.5.7;
pragma experimental ABIEncoderV2;

contract BasicEscrowBox {
    
  constructor () public {
    roundInfoReset();
  }

  enum STATE {
    OPEN,
    PROPOSING,
    NEGOTIATING,
    CANCELLING,
    FINALISING
  }

  enum ACTION {
    PROPOSE,
    NEGOTIATE,
    CANCEL,
    FINALISE
  }
  
  struct RoundInfo {
    bytes32 CurrentRoundId;
    uint256 RoundStartTime;
    uint256 ProposingTimeout;
    uint256 NegotiatingTimeout;  
  }

  RoundInfo public roundInfo;

  event StateUpdate (
    STATE   indexed currentState,
    STATE   indexed previousState,
    bytes32 indexed currentRoundId,
    uint256 timestamp
  );

  event ActionBy (
    address indexed actor,
    ACTION indexed action,
    bytes32 indexed currentRoundId,
    uint256 timestamp
  );
  
  modifier isTimeToPropose() {
    require(
      roundInfo.RoundStartTime == 0 || 
      block.timestamp <= roundInfo.RoundStartTime + roundInfo.ProposingTimeout
    );
    _;
  }
  
  modifier isTimeToNegotiate() {
    require(
      roundInfo.RoundStartTime + roundInfo.ProposingTimeout < block.timestamp &&
      block.timestamp <= roundInfo.RoundStartTime + roundInfo.ProposingTimeout + roundInfo.NegotiatingTimeout 
    );
    _;
  }
  
  modifier isTimeToFinalise() {
    require(
      roundInfo.RoundStartTime + roundInfo.ProposingTimeout + roundInfo.NegotiatingTimeout <= block.timestamp
    );
    _;
  }
  
  // https://solidity.readthedocs.io/en/v0.5.7/units-and-global-variables.html#abi-encoding-and-decoding-functions

  function propose (
    address _from,
    uint256 _value,
    bytes calldata _extra_data
  ) external returns (bool);

  function negotiate (
    address _from,
    uint256 _value,
    bytes calldata _extra_data
  ) external returns (bool);

  function cancel (
    address _from,
    uint256 _value,
    bytes calldata _extra_data
  ) external returns (bool);

  function finalise (
    address _from,
    uint256 _value,
    bytes calldata _extra_data
  ) external returns (bool);

  function proposeValidate   () internal returns (bool);
  function proposeCancel     () internal returns (bool);

  function negotiateValidate () internal returns (bool);
  function negotiateCancel   () internal returns (bool);

  function finaliseComplete  () internal returns (bool);
  
  function reset () internal returns (bool) {
    require(finaliseComplete());
    delete roundInfo;
    roundInfoReset();
  }
  
  function roundInfoReset() internal returns (bool) {
    roundInfo.ProposingTimeout = 100 minutes;
    roundInfo.NegotiatingTimeout = 100 minutes;
  }
}
