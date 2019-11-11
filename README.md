--------------------------------------------------------------------------
--------------------------------------------------------------------------
   I M P U L S E R P |  R O B    B A N K S
--------------------------------------------------------------------------
--------------------------------------------------------------------------
## Last Update: 11/11/2019
Updated read me file. Also fixed some alerts and timings to reflect the actual event. 
## Support
You can get support on my forums here:http://www.impulserp.com/forumdisplay.php?fid=11
## Background
I built this off the code from ElPumpo' esx_holdup. Alot of this is his code, so huge shout out to him. You can download his resource here: https://github.com/ESX-Org/esx_holdup

Right now, this is just the beginning. I plan to incorporate more banks, and more vaults. As well is incrase the complexity of the bank robberies. 

I am newer to LUA and JS. But I am having a blast learning about it, but consider the code a bit messy for the time being. I will fix it and any bugs that arise. 

NOTE:I have only been able to test it myself, so it may be qwerky with police notifications and what not. 

## How it Works
Simply go to Pacific Bank, go to the cash register w/ a weapon. Once the timer is up, you will receive a key and some cash to then make your way to the vault. That's where the real money is. You cannot access the vault without a key and you cannot have more than one key. Once you have accessed the vault, the key will be taken from you. I did this so that, you could either 
run in and get some quick risky cash, or lock the place down and try to make out with the big bucks. HAVE FUN!

# General Information
This resource is for ESX. It's primarily setup for robbing the Pacific Bank 

### Requirements
- [esx_policejob](https://github.com/ESX-Org/esx_policejob)

## Download & Installation

### Using [fvm](https://github.com/qlaffont/fvm-installer)
```
fvm install --save --folder=esx esx-org/esx_rabbanks
```

### Using Git
```
cd resources
git clone https://github.com/ESX-Org/esx_holdup [esx]/esx_robbanks
```

### Manually
- Download https://github.com/ESX-Org/esx_holdup/archive/master.zip
- Put it in the `[esx]` directory

## Installation
- Add this to your `server.cfg`:
```
start esx_robbanks
```
- Add importme.sql to your database

# Legal
### License
esx_rabbanks - rob banks

Copyright (C) 2015-2018 Jérémie N'gadi

This program Is free software: you can redistribute it And/Or modify it under the terms Of the GNU General Public License As published by the Free Software Foundation, either version 3 Of the License, Or (at your option) any later version.

This program Is distributed In the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty Of MERCHANTABILITY Or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License For more details.

You should have received a copy Of the GNU General Public License along with this program. If Not, see http://www.gnu.org/licenses/.
