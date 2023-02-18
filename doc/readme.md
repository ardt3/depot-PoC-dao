# EXEMPLE

## Etape 1 // Code solidity pour un smart contract permettant une gestion de fond

```solidity
// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract SimpleContract {
  uint public balance;

  function deposit() public payable {
      balance += msg.value;
  }

  function withdraw(uint amount) public {
      require(amount <= balance, "Insufficient funds");
      balance -= amount;
  }
}
```

__Attention ! Le code précédent est un simple exemple, il est important de dev un code solidity avec une gestion des erreurs et une sécurité importante__

Ce contrat a une seule fonctionnalité : il maintient un solde et permet à un utilisateur de déposer ou de retirer des fonds. La directive `pragma` définit la version minimale de Solidity requise pour compiler le contrat. La déclaration `contract` définit le début du contrat et son nom. La variable `balance` est une variable publique qui peut être lue par tout utilisateur. Les fonctions `deposit` et `withdraw` permettent aux utilisateurs de déposer ou de retirer des fonds. La fonction `require` vérifie que les conditions sont remplies avant d'exécuter le code suivant.

La variable `msg` est une instance de l'objet `msg` qui est disponible dans tous les contrats Solidity. Il contient des informations sur la transaction en cours et sur l'appelant. Les propriétés les plus couramment utilisées de `msg` sont `msg.sender` et `msg.value`.

- `msg.sender` représente l'adresse Ethereum de l'appelant de la fonction actuelle.
- `msg.value` représente la quantité de Ether transférée avec l'appel de fonction actuel.

Ces propriétés sont souvent utilisées pour gérer les transactions et les fonds dans les contrats intelligents. Par exemple, dans le code Solidity donné dans ma réponse précédente, la fonction `deposit` utilise `msg.value` pour ajouter la quantité de Ether reçue à la balance du contrat et la fonction `withdraw` utilise `msg.sender.transfer` pour transférer des fonds à l'appelant.

Les contrats Solidity n'ont pas de fonction principale comme dans les  programmes traditionnels. Au lieu de cela, les contrats Solidity sont  déclarés avec une directive `contract` et peuvent contenir  plusieurs fonctions publiques et privées qui peuvent être appelées à  partir de l'extérieur de la blockchain. Les fonctions publiques sont  accessibles depuis n'importe quelle adresse Ethereum, tandis que les  fonctions privées ne peuvent être appelées que depuis d'autres fonctions internes au contrat. Les fonctions publiques sont souvent utilisées  pour interagir avec le contrat et effectuer des transactions, tandis que les fonctions privées peuvent être utilisées pour gérer les données  internes du contrat.



## Etape 2 // Déploiement de la DAO sur la blockchain Ethereum

Pour déployer le code de votre DAO sur la blockchain Ethereum, vous pouvez utiliser un portefeuille compatible avec Ethereum, tels que MetaMask, ou un service de déploiement de contrats intelligents, tels que Remix, Infura, ou Bamboo Relay. Vous pouvez également développer une application front-end qui interagit avec votre contrat en utilisant une bibliothèque telle que Web3.js.

### Étapes générales pour déployer un contrat intelligent en utilisant Remix et Metamask

[Remix](https://remix.ethereum.org/#optimize=false&runs=200&evmVersion=null&version=soljson-v0.8.17+commit.8df45f5f.js)

1. ~~Installez l'extension Metamask sur votre navigateur.~~ (Inutile dans notre cas, tests sans ETH)

2. ~~Créez un nouveau compte ou connectez-vous à un compte existant.~~

3. Copiez le code Solidity de votre DAO dans un éditeur de code.

4. Allez sur la page Remix et copiez le code Solidity dans l'éditeur de code de Remix.

5. Cliquez sur le bouton "Compiler" __(1 et 2)__ pour compiler le code et vérifier qu'il n'y a pas d'erreur.

   ![](./remix1.png)

6. Cliquez sur le bouton "Déployer" __(1)__ pour déployer le contrat sur la blockchain Ethereum. Il faut configurer l'envirmonment de déploiement et les sous avec __(2)__

   ![](./remix2.png)

7. Metamask vous demandera de confirmer la transaction de déploiement en vous affichant une fenêtre contextuelle.

8. Après avoir confirmé la transaction, vous pouvez vérifier que le contrat a été déployé avec succès en consultant la blockchain Ethereum ou en utilisant un explorateur de blocs.

Note: Il est important de comprendre les concepts de déploiement de contrats intelligents et de sécurité liés à l'utilisation de Metamask avant de démarrer un projet de DAO.

### Déploiement de la DAO sans Remix -- Exemple avec le code et truffle

_Flemme de faire un tuto, d'installer `Node.js` `Truffle` `Etherum Client` et de vérifier si ce que je dis est vrais donc tu dis que tes incompétents et que c'est pas ton métier_

__Il faut dans un premier temps installer truffle et ses dépendance: [installation](https://trufflesuite.com/docs/truffle/how-to/install/)__

1. Créez un nouveau projet Truffle en utilisant la commande `truffle init`.
2. Copiez et collez le code Solidity dans un nouveau fichier avec l'extension `.sol` dans le répertoire `contracts` de votre projet Truffle.
3. Créez un nouveau fichier de migration dans le répertoire `migrations` de votre projet Truffle. Ce fichier décrira comment déployer votre contrat sur la blockchain. Vous pouvez utiliser le code suivant comme exemple:
4. Exécutez la commande `truffle migrate` pour déployer votre contrat sur la blockchain.
5. Vous pouvez interagir avec votre contrat déployé en utilisant le shell Truffle ou en écrivant un test pour votre contrat dans le répertoire `test` de votre projet Truffle à l'aide du framework de test _Mocha_ par exemple.

_Il est important de noter que pour utiliser Truffle, vous devez avoir un nœud Ethereum en cours d'exécution sur votre ordinateur. Vous pouvez  utiliser un nœud local 	en utilisant Geth ou Parity, ou vous pouvez vous  connecter à un nœud distant en utilisant un service en nuage tel que  Infura. Vous devez également configurer Truffle pour utiliser ce nœud en modifiant les paramètres de configuration dans le fichier `truffle-config.js` de votre projet._



## Etape 3 // Ajout d'un modèle de gouvrenance

```solidity
// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract SimpleContract {
  uint public balance;

  function deposit() public payable {
      balance += msg.value;
  }

  function withdraw(uint amount) public {
      require(amount <= balance, "Insufficient funds");
      balance -= amount;
  }
}

contract DAO {
  SimpleContract public simpleContract;
  uint public totalVotes;

  function vote(bool nb_vote) public {
    if (nb_vote){
        totalVotes += 1;
    }
    else {
        totalVotes -= 1;
    }
  }

  function executeWithdraw(uint amount) public {
    if (totalVotes >= (totalVotes / 2)) { // Plus de 50% doit être d'accord pour retirer de l'argent
      simpleContract.withdraw(amount);
    }
  }
}
```



Dans ce code, nous avons ajouté un contrat `DAO` qui comporte une référence au contrat `SimpleContract`. La fonction `vote` permet aux participants de voter pour ou contre une proposition en ajoutant ou soustraisant un vote. La fonction `executeWithdraw` ne peut être appelée que si la majorité des votes est atteinte et permet de définir la valeur à retirer dans le contrat `SimpleContract`.



## Etape 4 // Permettre aux utilisateurs d'interagir avec la DAO

![](./web.png)

On peut obtenir l'interface web précedente à l'aide du code suivant. Cette interface communique avec le contrat et permet de retirer ou de deposer de l'argent. Vous pouvez utiliser un fichier `index.html` (fichier suivant) qui inclut une  interface utilisateur web avec JavaScript. Cette interface utilisateur  peut être utilisée pour envoyer des transactions à la DAO en utilisant  une bibliothèque telle que `web3.js`.

```html
<!DOCTYPE html>
<html>
  <head>
    <script src="https://cdn.jsdelivr.net/gh/ethereum/web3.js@1.0.0-beta.34/dist/web3.min.js"></script>
    <script type="text/javascript">
      const ABI = [
        {
          "inputs": [],
          "name": "deposit",
          "outputs": [
            {
              "internalType": "uint256",
              "name": "",
              "type": "uint256"
            }
          ],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [
            {
              "internalType": "uint256",
              "name": "amount",
              "type": "uint256"
            }
          ],
          "name": "withdraw",
          "outputs": [],
          "stateMutability": "nonpayable",
          "type": "function"
        }
      ];
      const contractAddress = 'contract-address';

      window.addEventListener('load', async () => {
        if (typeof web3 !== 'undefined') {
          window.web3 = new Web3(web3.currentProvider);
        } else {
          window.web3 = new Web3(new Web3.providers.HttpProvider('http-provider-url'));
        }
        const contract = new web3.eth.Contract(ABI, contractAddress);

        document.getElementById('deposit').addEventListener('click', async () => {
          const value = await contract.methods.getValue().call();
          document.getElementById('value').innerHTML = value;
        });

        document.getElementById('withdraw').addEventListener('click', async () => {
          const value = parseInt(document.getElementById('inputValue').value, 10);
          await contract.methods.setValue(value).send({ from: web3.eth.defaultAccount });
        });
      });
    </script>
  </head>
  <body>
    <h1>Simple Contract</h1>
    <br>
    <input id="inputValue" type="text">
    <button id="withdraw">Withdraw</button>
    <button id="deposit">Deposit</button>
    <div id="value"></div>
  </body>
</html>
```

Cette interface n'inclus pas le modèle de gouvernance puisqu'il faudrait utiliser des utiliser des bibliothèques d'interface utilisateur telles que React, Angular, Vue.js, etc. ~~qui me sont inconnus :(~~











​	

 