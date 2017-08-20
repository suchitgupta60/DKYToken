pragma solidity ^0.4.11;

import './IERC20.sol';
import './SafeMath.sol';

contract DKYToken is IERC20 {
    using SafeMath for uint256; 
    
    uint public _totalSupply = 50000000000000000000000000;
    
    string public constant symbol = "BELL";
    string public constant name = "Bella Enterprises";
    uint8 public constant decimals = 18;

    //1 Ether = 10000 DKY token
    uint256 public constant RATE = 10000;
    
    address public owner;
    
    mapping(address => uint256) balances; 
    mapping(address => mapping(address => uint256)) allowed;
    
    function () payable {
        createTokens();
    }
    
    function DKYToken(){
        owner = msg.sender;
    }
    
    function createTokens() payable {
        require(
            msg.value > 0
            );
            uint256 tokens = msg.value.safeMul(RATE);
            balances[msg.sender] = balances[msg.sender].safeAdd(tokens);
            _totalSupply = _totalSupply.safeSub(tokens);
            owner.transfer(msg.value);
    }
    
    function totalSupply() constant returns (uint256 totalSupply){
        return _totalSupply;
    }
    
    function balanceOf(address _owner) constant returns (uint256 balance){
        
        return balances[_owner];
    }
    
    function transfer(address _to, uint256 _value) returns (bool success){
        require(
            balances[msg.sender] >= _value
            && _value > 0
            );
            balances[msg.sender] = balances[msg.sender].safeSub(_value);  
            balances[_to] = balances[_to].safeAdd(_value);
            Transfer(msg.sender, _to, _value);
            return true;
    }
    
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
        require(
            allowed[_from][msg.sender] >= _value
            && balances[_from] >= _value
            && _value > 0
            );
            balances[_from] = balances[_from].safeSub(_value);
            balances[_to] = balances[_to].safeAdd(_value);
            allowed[_from][msg.sender] = allowed[_from][msg.sender].safeSub(_value);
            Transfer(_from, _to, _value);
            return true;
    }
    
    function approve(address _spender, uint256 _value) returns (bool success){
        allowed[msg.sender][_spender] = _value; 
        Approval(msg.sender, _spender, _value);
        return true;
    }
    
    function allowance(address _owner, address _spender) constant returns (uint256 remaining){
        return allowed[_owner][_spender];
    }
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}