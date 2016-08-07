# lottery
Ethereum smart contract powerball lottery

This project is another learning opportunity on how to build smart contracts and understanding limitations on the Solidity programming language. The original design had to be modified 3 times in order to accomodate the programming paradigm of Solidity. Due to limitations in securely generating random numbers, the inability to iterate through mappings, clearing mappings and understanding how gas affects computation cost, the design required the following changes:

1. A single smart contract can be used for a single lottery play. Subsequent lottery games require deploying another smart contract. This is to work around the issue that once users have played, the mapping(address => Bet[]) can not be cleared or deleted. Therefore, players' bets cannot be removed.
2. Instead of automatically iterating through all the bets (which could use up a lot of gas) and rewarding winners automatically as originally intended, the smart contract had to be modified so that players would have to check themselves whether they had won. Players are given a certain period of time to check whether they won before payouts are awarded.
3. Providing a robust number generator that cannot be manipulated by miners (per the various discussions on this topic on the web) is difficult at best. For simplicity, I opted for the lottery administrator to specify the winning numbers (whiteballs and powerball).

the next phase of this project is to build a web application to provide a web interface to the lottery game. This web app will provide the remaining scaffolding necessary:
- user interface for players to play. this involves capturing the player's key, bet amount and numbers chosen.
- sorting the whiteballs before calling the smart contract since there is no sorting functionality in Solidity.
- user interface for the game administrator to specify the winning numbers.
- user interface for players to see who won and how much.

Please provide comments and improvements as this project is a learning opportunity. 
