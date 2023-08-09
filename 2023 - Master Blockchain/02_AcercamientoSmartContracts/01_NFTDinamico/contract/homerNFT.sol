// SPDX-License-Identifier: MIT

//Creado por Jonatan Gomez Garcia gracias a las clases de Bitlab
pragma solidity ^0.8.9;

import "@openzeppelin/contracts@4.8.2/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.8.2/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.8.2/access/Ownable.sol";
import "@openzeppelin/contracts@4.8.2/utils/Counters.sol";
import "@chainlink/contracts/src/v0.8/AutomationCompatible.sol";

contract Homer is ERC721, ERC721URIStorage, Ownable, AutomationCompatibleInterface {
    using Counters for Counters.Counter;

    string[] IpfsUri = [
        "https://gateway.pinata.cloud/ipfs/QmavFFBcRNvpUHHj9Bbv7ZqhF3zibzAsKUJNJs7J1YAZT3/homer_0.json",
        "https://gateway.pinata.cloud/ipfs/QmavFFBcRNvpUHHj9Bbv7ZqhF3zibzAsKUJNJs7J1YAZT3/homer_1.json",
        "https://gateway.pinata.cloud/ipfs/QmavFFBcRNvpUHHj9Bbv7ZqhF3zibzAsKUJNJs7J1YAZT3/homer_2.json"
    ];

    Counters.Counter private _tokenIdCounter;

    uint interval;
    uint lastTimeStamp;

    constructor(uint _interval) ERC721("CardNFT", "dNFT") {
        interval = _interval;
        lastTimeStamp = block.timestamp;
    }


    function safeMint(address to) public {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);        
        _setTokenURI(tokenId, IpfsUri[0]);
    }

    function pympMyRide(uint256 _tokenId) public{
        require(homerLevel(_tokenId) < 2, "Homer totalmente cabreado!");

        // obtiene el valor actual del auto y le suma 1
        uint256 newVal = homerLevel(_tokenId) + 1;
        // store the new URI
        string memory newUri = IpfsUri[newVal];
        //Update the URI
        _setTokenURI(_tokenId, newUri);
    }

    // helper functions
    //
   function homerLevel(uint256 _tokenId) public view returns(uint256){
        string memory _uri = tokenURI(_tokenId);

        uint result;
        //Guardamos el factor comparador para una mejor eficiencia en cuanto a consumo de gas
        bytes32 toFind = keccak256(abi.encodePacked(_uri));
        
        for (uint256 index = 0; index < IpfsUri.length; index++) {            
            if(keccak256(abi.encodePacked(IpfsUri[index])) == toFind)
                result = index;
        }
        return result;
    }

    function checkUpkeep(bytes calldata /* checkData */) external view override returns (bool upkeepNeeded, bytes memory /* performData */) {
        upkeepNeeded = (block.timestamp - lastTimeStamp) > interval;        
    }

    function performUpkeep(bytes calldata /* performData */) external override  {        
        if ((block.timestamp - lastTimeStamp) > interval ) {
            lastTimeStamp = block.timestamp;

            uint counter = _tokenIdCounter.current();

            for (uint256 index = 0; index < counter; index++) {            
                if(homerLevel(index) < 2){
                    pympMyRide(index);
                    break;
                }                
            }            
        }        
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
}
