# DAO

## Problème dans la demande 
Votre KYC _(?? Questionnaire ??)_ nécessite plus de clarté. Vous vouliez un questionnaire général qui permet d'initialiser la gouvernance de la DAO si j'ai bien compris. \
Si vous donnez un questionnaire à l'utilisateur (Questionnaire codifié dans la DAO en Solidity). Ça veut dire que la DAO est déjà déployé et là ça pose plusieurs 
problèmes, dont 3 que j'ai remarqué (peut-être plus...) :

1. Normalement la gouvernance doit être codée en dure dans le code, en théorie elle n'est pas censée être modifiée alors que le contrat est déployé _(ce que vous voulez faire)_
2. Solidity n'est __PAS UN LANGUAGE INTERATIF__, j'ai peut être pas respecter votre demande pour la KYC mais il y a une raison à cela. On ne peut pas poser des questions à un utilisateur en solidity comme on le ferait avec un `scanf` en C. Donc si on ne peut pas poser de questions il faut passer par une interface utilisateur (web par exemple), vous pouvez à la limite envoyer un signal à l'api pour dire qu'il faut poser une question. Comme je l'ai dit je n'ai pas prévu de faire du web et encore moins de perdre du temps à apprendre React ou Angular pour l'utiliser qu'une fois. \
3. Donc dans l'idée (je dis bien dans l'idée), je me suis dit que vous pouvez demandé a un dev web de faire une interface web qui fera votre KYC, deploy le contrat et appeler la fonction `setGeneralGovernance(...)` avec en arg les réponses à votre questionnaire. \
Mais encore une fois, il y a un problème. Cette solution marche techniquement, j'ai pu la tester (avec un script de test pas une ui graphique). Mais imagine y'a un hacker qui passe par là et il arrive a accéder au code de la DAO, à tout moment il change les règles de gouvernance et vole tout le pognon. 

C'est à vérifier je suis pas un pro solidity, mais avec quelque recherche j'ai l'impression que votre histoire est bancale (à vérifier).

## Création de l'environement de dev Etherum avec Hardhat 

### __Installation de `npm`__:

1. MacOS:

   ```bash
   $ brew install npm
   ```

2. Linux:

   ```bash
   $ sudo apt install npm
   ```


### __Création du projet__:

```bash
$ mkdir dao && cd dao # création et ouverture du dossier de travail 
$ npm install -d hardhat # installation de hardhat dans le dossier
```

![](/.img/hardhat1.png)

```bash
$ npm install --save-dev @nomiclabs/hardhat-ethers ethers @nomiclabs/hardhat-waffle ethereum-waffle chai # installation de plugin
```
```bash
$ mkdir contracts && cd contracts # Création du dossier contracts, il doit contenir tous les contrats
$ touch dao.sol # Création du contrat dao.sol
```

```bash
$ mkdir test && cd test # Création du dossier test, il doit contenir tous les test
$ touch test.js # Création du script de test test.js
```

Vous devez obtenir la structure de fichier suivante si tout est bon
```
dao
├── contracts
│   └── dao.sol
├── hardhat.config.js
├── node_modules
│   └── ...
├── test
│   └── test.js
├── package-lock.json
└── package.json
```

### Configuration de _Hardhat_
```js
/**
 * @type import('hardhat/config').HardhatUserConfig
 */

require("@nomiclabs/hardhat-waffle");
//const Private_Key = "ADD_YOUR_PRIVATE_KEY"

module.exports = {
  solidity: "0.8.17", // version du compilo 
  //networks: { // si vous voulez déployer sur un réseau
  	//ropsten: {
  		//url: `ADD_YOUR_QUICKNODE_URL_HERE`,
  		//accounts: [`0x${Private_Key}`]
  	//}
  //}
};
```

## Réalisation du code _solidity_
_(C'est un extrait de contracts/dao.sol)_
```solidity
// SPDX-License-Identifier: GPL-3.0   
pragma solidity ^0.8.0; // la version de solidity

// différent plugin utilisé, ex openzeppelin
import "@openzeppelin/contracts/access/AccessControl.sol";

// Un contrat: Dao
contract Dao {

    mapping(address => bool) public members; // toute les adresses sont dirigés vers une sorte de dico de boolean (0 il est pas membre, 1 il est membre)
    uint256 public memberCount;

    struct User{ // Une structure par utilisateur toto en a une et tata aussi, chacun ses info
        string name;
        string country;
        bool isOwner;
        address addr;
    }

    struct GovernanceValue{ // Une seul instance, c'est déjà trop. Contient les regles de la gouvernance
        uint8 nbUserMax;
        bool profitable;
        string contractType;        
    }

    GovernanceValue public governance;


    // fonction qui permet de set la governance suite aux réponses de la KYC
    function setGeneralGovernance(User memory user, uint8 nbUserMax, bool profitable, string memory contractType) public{ // add args
        require(user.isOwner, "Only owner can set the governance"); // seulement le owner peut set la governance

        governance.nbUserMax = nbUserMax;
        governance.profitable = profitable;
        governance.contractType = contractType;
    }

    function createNewUser(string memory name, string memory country, bool isOwner) public view returns(User memory){
        User memory newUser; 

        newUser.name  = name;
        newUser.country = country;
        newUser.isOwner = isOwner;
        newUser.addr = msg.sender;

        return newUser;
    }

    function addUser(User memory newUser) public {
        // Il faut que le membre existe pas et que la limite ne soit pas atteinte pour l'ajouter
        require(!members[newUser.addr], "Member already exist");
        require(memberCount < governance.nbUserMax, "The limit of the number of users has been reached");

        members[newUser.addr] = true;
        memberCount++;
    }

    function removeUser(User memory userToRemove) public {
        require(members[userToRemove.addr], "Member doesn't exist");

        members[userToRemove.addr] = false;
        memberCount--;
    }
}

// Vous pouvez avoir plusieurs contrat dans un seul fichier, mais autant en faire plusieurs
// si vous en faite un sous le nom de toto.sol vous pouvez l'ajouter avec import "toto.sol" dans l'entête
contract toto {

}
```

### Compilation
```bash
$ npx hardhat compile 
Compiled 21 Solidity files successfully
```

### Test 
Les tests sont executés sur une blockchain local donc des ETH virtuels


#### Ecriture d'un test 
_(C'est un extrait de test/test.js)_
```js
//plugins nécessaire pour le test
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Dao", function() {

  let dao;
  let owner;
  let user1;
  let user2;
  let user3;
  let user4;
  let user5;

  // réaliser à chaque test
  beforeEach(async () => {
    const Dao = await ethers.getContractFactory("Dao"); // création du contrat
    [owner, user1, user2, user3, user4, user5] = await ethers.getSigners(); // création des id des users addr ether...
    dao = await Dao.deploy(); // deploiement du contrat

            // await --> asynchrone on att la fin de la fct
    owner = await dao.connect(owner.address).createNewUser("Tartempion Toto", "FR", true); // appel a une fonction du contrat dao
    await dao.setGeneralGovernance(owner, 5, true, "contract");

    user1 = await dao.connect(user1.address).createNewUser("Tartempion Tutu", "EN", false);
    user2 = await dao.connect(user2.address).createNewUser("Tartempion Titi", "EN", false);
    user3 = await dao.connect(user3.address).createNewUser("Tartempion Tata", "EN", false);
    
    await dao.addUser(owner);
    await dao.addUser(user1);
    await dao.addUser(user2);
    await dao.addUser(user3);
  });

  // premier test
  it("should be pass", async function() {
    await dao.createProposal("Description", owner.addr);
    await dao.vote(0, user1.addr);
    await dao.vote(0, user2.addr);
    await dao.execProposal(0);
  });

  it("shouldn't work, the proposal is not voted enough ", async function() {
    // il peut y en avoir plusieurs, beaforeEach sera executer à chaque fois
  });
});
```

#### Execution du test
```
$ npx hardhat test 
  Dao
    ✔ should be pass (78ms)
    1) shouldn't work, the proposal is not voted enough 
    2) shouldn't work, a non-member is trying to create a proposal
    3) shouldn't work, a non-member is trying to vote
    4) shouldn't work, a non-owner is trying to set the general governance
    5) shouldn't work, too many registered users


  1 passing (2s)
  5 failing
```
