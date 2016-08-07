
contract Lottery 
{
    address admin;
    uint fee;
    uint end;
    uint redemption;
    uint constant betamount = 100;
    uint totalPot;
    uint whiteballs;
    uint powerball;

    struct Bet {
        uint amount;
        uint whiteballs;
        uint powerball;
    }

    // mapping of ticket number to player.
    mapping(address => Bet[]) lotto;
    // list of winners.
    address[] winners;

    modifier AdminOnly() {
        if (msg.sender == admin) {
            _   // continue
        }
    }

    modifier InPlay() {
        if(msg.sender != admin && block.timestamp < end) {
            _   // continue
        }
    }
    
    modifier EndPlay() {
        if(msg.sender != admin && 
            block.timestamp >= end &&
            block.timestamp < redemption) {
            _   // continue
        }
    }
    event Logging(string output, address caller);
    
    // constructor
    function Lottery(uint feePercent, uint unixEndTime, uint daysToRedeem) {
        if(admin != address(0)) {
            throw;
        }
        
        fee = feePercent;
        end = unixEndTime;
        redemption = daysToRedeem * 86400; // unix seconds in a day.
        totalPot = 0;
        admin = msg.sender;
    }
    
    function DrawWinning(uint _whiteballs, uint _powerball) AdminOnly EndPlay {
        whiteballs = _whiteballs;
        powerball = _powerball;
    }

    function DisburseEarnings() AdminOnly EndPlay {
        // split pot amongst winners minus administrative fee of 15%.
        uint _earnings = (totalPot - (totalPot * fee)) / winners.length;
        
        // disburse winnings.
        for(uint i = 0; i < winners.length; i++) {
            if(!winners[i].send(_earnings)) {
                throw;
            }
        }
    }    
    
    function Play(uint _whiteballs, uint _powerball) InPlay {
    	// check betting amount is correct.
    	if(msg.value != betamount) {
            Logging("bet amount is incorrect", msg.sender);
    		return;
    	}

        // check if user hasn't already played the same number. 
        Bet[] _playerbets = lotto[msg.sender];
        // prevent players from playing the same number multiple times.
        for(uint i = 0; i < _playerbets.length; i++) {
            if(_playerbets[i].whiteballs == _whiteballs) {
                Logging("betting on the same number not permitted", msg.sender);
                return;
            }
        }

        // add bet to pot.
        totalPot += msg.value;
        
        // track player's bet.
        lotto[msg.sender].push(Bet({
        	amount: msg.value,
        	whiteballs: _whiteballs,
        	powerball: _powerball
        	}));
    }
    
    function Check() EndPlay {
        if(whiteballs == 0 && powerball == 0) {
            Logging("please check again. Winning balls have not been drawn yet.", msg.sender);
            return;
        }
        
        var _bets = lotto[msg.sender];
        
        for(uint i = 0; i < _bets.length; i++) {
            if( _bets[i].whiteballs == whiteballs && 
                _bets[i].powerball == powerball) {
                Logging("You're a PowerBall winner!", msg.sender);
                // track winners.
                winners.push(msg.sender);
            }
        }
    }
    
    function () {
        throw;
    }
}