// SPDX-License_Identifier: UNLICENSED
pragma solidity 0.8.4;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CryptoRugsNFT is ERC721A, Ownable {
    uint256 public mintPrice;
    uint256 public maxSupply;
    uint256 public maxPerWallet;
    bool public isPublicMintEnabled;
    string internal baseTokenUri;
    address payable public withdrawWallet;

    constructor(address payable _withdrawWallet)
        payable
        ERC721A("CryptoRugsNFT", "CR")
    {
        mintPrice = 0.02 ether;
        maxSupply = 1000;
        maxPerWallet = 3;
        withdrawWallet = _withdrawWallet;
    }

    function setIsPublicMintEnabled(bool _isPublicMintEnabled)
        external
        onlyOwner
    {
        isPublicMintEnabled = _isPublicMintEnabled;
    }

    function setBaseTokenUri(string calldata _baseTokenUri) external onlyOwner {
        baseTokenUri = _baseTokenUri;
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        override
        returns (string memory)
    {
        require(_exists(_tokenId), "Token does not exist");
        return
            string(
                abi.encodePacked(baseTokenUri, _toString(_tokenId), ".json")
            );
    }

    function withdraw() external onlyOwner {
        (bool success, ) = withdrawWallet.call{value: address(this).balance}(
            ""
        );
        require(success, "withdraw failed");
    }

    function mint(uint256 _quantity) external payable {
        require(isPublicMintEnabled, "Minting not enabled");
        require(msg.value == _quantity * mintPrice, "Wrong mint value");
        require(totalSupply() + _quantity <= maxSupply, "Sold out");
        require(
            balanceOf(msg.sender) + _quantity <= maxPerWallet,
            "Exceeded max wallet"
        );

        _safeMint(msg.sender, _quantity);
    }
}
