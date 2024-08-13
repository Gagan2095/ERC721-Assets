// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

//@author: Gagan2095
contract Token {
    string public name;

    string public symbol;

    address private owner;

    mapping(address owner => uint256) public balanceOf;

    mapping(uint256 tokenId => address) public ownerOf;

    mapping(uint256 tokenId => address) public approvals;

    mapping(address => mapping(address => bool)) isApprovedForAll;

    mapping(uint256 tokenId => uint256 price) tokenPrice;

    /// @notice Logs the address of both the parties of an transaction with the value to be sent
    /// @param _from the sender address of the transaction
    /// @param _to the reciever address of the transaction
    /// @param _tokenId the token to be sent in the transaction
    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 indexed _tokenId
    );

    /// @notice Logs the address of both the parties of an approval with the tokenId
    /// @param _owner the ownder of the token
    /// @param _approved the reciever who is getting approval
    /// @param _tokenId Id of the token
    event Approval(
        address indexed _owner,
        address indexed _approved,
        uint256 indexed _tokenId
    );

    /// @notice Logs the address of both the parties of an approval for all the NFTs 
    /// @param _owner the ownder of the token
    /// @param _operator the reciever who is getting approval permission
    /// @param _approved Id of the token
    event ApprovalForAll(
        address indexed _owner,
        address indexed _operator,
        bool _approved
    );

    /// @notice Logs the message on unAuthorized access  
    error unAuthorized();

    /// @notice Logs the message on getting zero address
    error zeroAddress();

    /// @notice Log the id of the token when it is invalid
    /// @param tokenId the id of the provided token
    error inValidNFT(uint256 tokenId);

    /// @notice Logs the address of the recepient where the token are going to be minted and the new _tokenId
    /// @param _recepient the reciever address of the transaction
    /// @param _tokenId the token to be sent in the transaction
    event tokenMinted(
        address indexed _recepient,
        uint256 indexed _tokenId
    );

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
        owner = msg.sender;
    }

    modifier checkUnAuthorized(address add1,address add2) {
        if(add1!=add2) revert unAuthorized();
        _;
    }

    /// @notice safely transfer the token from the _from address to the _to address
    /// @param _from address to which token will be send
    /// @param _to value of token to be sent
    /// @param _tokenId id of the token
    /// @param data value depends on successfull transfer
    // function safeTransferFrom(
    //     address _from,
    //     address _to,
    //     uint256 _tokenId,
    //     bytes memory data
    // ) external payable {
    //     if (_from == ownerOf[_tokenId])
    //         revert unAuthorized("from is not equal to owner");
    //     if (_to != address(0)) revert zeroAddress("address to is zero address");
    //     if (ownerOf[_tokenId] == address(0)) revert inValidNFT(_tokenId);
    //     ownerOf[_tokenId] = _to;
    //     balanceOf[_from]--;
    //     balanceOf[_to]++;
    //     emit Transfer(_from, _to, _tokenId);
    // }

    /// @notice safely transfer the token from the _from address to the _to address
    /// @param _from address to which token will be send
    /// @param _to value of token to be sent
    /// @param _tokenId id of the token
    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    )
        external 
        payable 
        checkUnAuthorized(_from, ownerOf[_tokenId]){
        if (_to != address(0)) revert zeroAddress();
        if (ownerOf[_tokenId] == address(0)) revert inValidNFT(_tokenId);
        ownerOf[_tokenId] = _to;
        balanceOf[_from]--;
        balanceOf[_to]++;
        emit Transfer(_from, _to, _tokenId);
    }

    /// @notice transfer the token from the _from address to the _to address
    /// @param _from address to which token will be send
    /// @param _to value of token to be sent
    /// @param _tokenId id of the token
    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external payable {
        ownerOf[_tokenId] = _to;
        balanceOf[_from]--;
        balanceOf[_to]++;
        emit Transfer(_from, _to, _tokenId);
    }

    /// @notice approve the _approved address to send token on behalf of msg.sender
    /// @param _approved the address who is getting the approval for _tokendId
    /// @param _tokenId the id of the token
    function approve(address _approved, uint256 _tokenId) 
        external 
        payable 
        checkUnAuthorized(ownerOf[_tokenId], msg.sender){
        if (ownerOf[_tokenId] == address(0)) revert inValidNFT(_tokenId);
        approvals[_tokenId] = _approved;
        emit Approval(ownerOf[_tokenId], _approved, _tokenId);
    }

    /// @notice giving approval for all the tokens of msg.sender to the _operator
    /// @param _operator the address of the user who is getting the approval 
    /// @param _approved boolean value whether granting the approval or revoke
    function setApprovalForAll(address _operator, bool _approved) external {
        isApprovedForAll[msg.sender][_operator] = _approved;
    }

    /// @notice return the address of the approval party of the _token
    /// @param _tokenId the id of the token
    /// @return address of the owner 
    function getApproved(uint256 _tokenId) external view returns (address) {
        return ownerOf[_tokenId];
    }

    /// @notice creating new tokens , can only be done by the deployer of the contract
    /// @param _owner the id of the token
    /// @param tokenId of the owner
    function mint(address _owner, uint256 tokenId) external checkUnAuthorized(owner, msg.sender){
        ownerOf[tokenId] = _owner;
        balanceOf[_owner]++;
        emit tokenMinted(_owner, tokenId);
    }

    /// @notice set the price of the token in terms of "Coins", only the owner of the token can set the price
    /// @param tokenId the id of the token
    /// @param price the value of the price to be set on the token
    function setPrice(uint256 tokenId,uint256 price) 
        external 
        checkUnAuthorized( ownerOf[tokenId], msg.sender){
        tokenPrice[tokenId] = price;
    }

    /// @notice destroying the existing tokens from the _owner address , can only be done by the deployer of the contract
    /// @param _owner the id of the token
    /// @param tokenId of the owner
    function burn(address _owner, uint256 tokenId) 
        external 
        checkUnAuthorized(_owner, msg.sender){
        delete ownerOf[tokenId];
        balanceOf[_owner]--;
        emit Transfer(address(0), _owner, tokenId);
    }

}