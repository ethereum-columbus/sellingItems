pragma solidity ^0.4.21;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/SupplyChain.sol";

contract TestSupplyChainOther {
    uint public initialBalance = 1 ether;
    SupplyChain public chain;

    function beforeEach() public
    {
        chain = new SupplyChain();
    }

    // Test for failing conditions in this contracts
    // test that every modifier is working
    function testItemCanBePutOnSale() public {
        string memory itemName = "Gem";
        uint   itemPrice = 3;
        chain.addItem(itemName, itemPrice);

        uint expectedState = 0; // 0: Sale
        uint expectedSku = 0;
        address expectedBuyer = address(0);
        address expectedSeller = this;

        string memory name;
        uint sku;
        uint price;
        uint state;
        address seller;
        address buyer;

        ( name, sku, price, state, seller, buyer) = chain.fetchItem(expectedSku); // the first item

        Assert.equal(sku, expectedSku, "Item sku is correct");
        Assert.equal(name, itemName, "Item is named correctly");
        Assert.equal(price, itemPrice, "Item price correctly");
        Assert.equal(state, expectedState, "Item State is `For sale`");
        Assert.equal(buyer, expectedBuyer, "Item buyer is 0x0");
        Assert.equal(seller, expectedSeller, "Item seller is me");
    }

    function testUserDoesNotPaysTheRightPrice() public payable {
        string memory itemName = "Gem";
        uint   itemPrice = 3;
        chain.addItem(itemName, itemPrice);

        uint sku = 0;
        uint offer = itemPrice - 1; // low ball price

        bool result = address(chain).call.value(offer)(abi.encodeWithSignature("buyItem(uint256)", sku));
        Assert.isFalse(result, "under Paid for item");
    }

    function testUserPaysTheRightPrice() public payable {
        string memory itemName = "Gem";
        uint   itemPrice = 3;
        chain.addItem(itemName, itemPrice);

        uint sku = 0;
        uint offer = itemPrice + 1; // low ball price
        bool result = address(chain).call.value(offer)(abi.encodeWithSignature("buyItem(uint256)", sku));
        Assert.isTrue(result, "Paid the correct price...");
    }

    // buyItem

    // test for failure if user does not send enough funds
    // test for purchasing an item that is not for Sale


    // shipItem

    // test for calls that are made by not the seller
    // test for trying to ship an item that is not marked Sold

    // receiveItem

    // test calling the function from an address that is not the buyer
    // test calling the function on an item not marked Shipped

    function() public payable {}
}
