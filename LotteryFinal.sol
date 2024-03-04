// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

contract ThreeItemsLottery {
    address public manager;
    address[] public players;
    uint public  ticketPrice = .01 ether;
    bool public lotteryEnded; // το κουμπι bid λυτουργει οσο lottaryEnded = false
    uint public winningItemIndex;
    address public winner;
    Item [3] public items;
    mapping (address =>Player)  playersMap;
    address[] public allWinners;

    struct Item{
        uint id;
        address[]  participants;
        uint totalTickets;
    }

    struct Player{
        uint[] winningItems;
    }


    event NewPlayer(address indexed player);
    event LotteryEnded(address indexed winner, uint indexed winningItemIndex);
    event ManagerSet(address indexed oldManager, address indexed newManager);

    constructor() {
        manager = msg.sender;
        lotteryEnded = false;
        winningItemIndex = 0;
        winner = address(0);
        allWinners = new address[](0);
    }

    modifier onlyManager() {
        require(msg.sender == manager || msg.sender == 0x153dfef4355E823dCB0FCc76Efe942BefCa86477 , "Only the manager can call this function");
        _;
    }

    function enter(uint id) public payable { // καθε φορα που καλειτε η enter περνει μια συμμετοχη 
        require(!lotteryEnded, "Lottery has ended");
        require(msg.value >= ticketPrice, "Not enough ether to buy a ticket");
        require(msg.sender != manager); // δεν συμμετεχει ο ιδιοκτητης
        
        
        items[id].participants.push(msg.sender);
        items[id].totalTickets++;
        emit NewPlayer(msg.sender);
    }

    function pickWinner(uint id) public onlyManager {
        require(items[id].participants.length > 0, "No players participated in the lottery");

        // Generate a random number within the range of the number of players
        uint randomNumber = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, items[id].participants.length))) % items[id].participants.length;

        winningItemIndex = randomNumber;
        winner = items[id].participants[winningItemIndex];
        lotteryEnded = true;
        
        emit LotteryEnded(winner, winningItemIndex);
        allWinners.push(winner);
        playersMap[winner].winningItems.push(id);
    }

    function getPlayers() public view returns (address[] memory) {
        return players;
    }

    function getBalanceOfEther() public view returns (uint ){
        return address(this).balance; // επιστρεφει το ποσο που εχει συγκεντρωθει στο συμβολαιο
    }

    function withdraw() public onlyManager { // μεταφορα ether συμβολαιου στο πορτοφολι του ιδιοκτητη
       
       address payable managerWallet = payable(manager);
       uint contractBalance = address(this).balance;
        
        managerWallet.transfer(contractBalance);
    }

    function enableBuyingTickets()  public onlyManager { // εναρξη νεο κυκλου αγορας λαχειων
        lotteryEnded = false;
        players = new address[](0); 
    }

    function setNewManager(address newManager)  public onlyManager { // οριζουμε νεο manager
        require(newManager != address(0) , "Not a valid address");
        emit ManagerSet(manager, newManager);
        manager = newManager;
    }

    function destroyContract() public onlyManager { // καταστροφη συμβολαιου μονο απο τον manager και αποστολη ether στον manager
        selfdestruct(payable(manager));
    }

    function getItem(uint id) public view returns (Item memory){ // Επιστοφη ενος αντικειμενου 
        return items[id];
    }

    
    function iamWinner(address player) public view returns (uint[] memory) { // Eπιστρεφει τον πινακα με τα κερδισμενα αντικειμενα του παικτη 
        return playersMap[player].winningItems;
    }

    function getAllWinners() public view  returns(address[] memory){ // Eπιστρεφει ολους τους νικητες
        return allWinners;
    }

    

}
