
import 'package:encrypt/encrypt.dart';

import 'KDC.dart';
import 'usuario.dart';


void main(){


// Cria os usuários
Usuario bob = new Usuario("Bob");
Usuario alice = new Usuario("Alice");



// Bob solicita uma chave de sessão com Alice
var solicitacaoBob = bob.solicitarChaveSessao(alice, bob.chaveMestre);

decifraDesejo(bob.nome, solicitacaoBob);

//É declarado a sessão Bob e alice
Map<String, String> sessao = {bob.nome: alice.nome};


// A chave é distribuida para os membros da sessão
alice.receberChaveSessao(sessao);
bob.receberChaveSessao(sessao);

print("Chave de sessão de Alice: " + alice.chaveSessao );
print("Chave de sessão de Bob: " + bob.chaveSessao);


// Bob envia um nonce cifrado para Alice
Encrypted nonceDeBob = bob.enviarMensagem("Alice, faça a seguinte conta: 1839+32423*3");
print("\nnonce de Bob cifrado: " + nonceDeBob.base64);
// Alice recebe o nonce de Bob e o decifra
String decifraDeAlice = alice.receberMensagem(nonceDeBob);
print("nonce de Bob decifrado por Alice: " + decifraDeAlice);

// Alice exerce a função pedida por Bob
int contaDeBob = 1839+32423*3;
//Alice responde cifradamente o nonce de Bob
Encrypted respostaAlice = alice.enviarMensagem("Bob, o resultado é: $contaDeBob");
print("\nResposta cifrada de Alice: " + respostaAlice.base64);

// Bob recebe a resposta
String decifraDeBob = bob.receberMensagem(respostaAlice);

Encrypted respostadeBob = bob.enviarMensagem("Boa noite!");

print("Mensagem clara de Bob: " + decifraDeAlice);
print("\nResposta de Alice a Bob: " + decifraDeBob);
print("Resposta cifrada de Bob: " + respostadeBob.base64);
}


