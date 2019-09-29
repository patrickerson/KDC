import 'dart:core';
import 'dart:math';
import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'AES.dart';



// Distribui as chaves para Bob e Alice
Map chavesMestresCompartilhadas = {
  "Bob": gerarChave(), 
  "Alice": gerarChave(),};

// Armazena as chaves de Sessao

Map<Map<String,String>,String> chavesSessaoCompartilhadas = {};





// Recebe o desejo cifrado de um requisitante, descifra, e executa
void decifraDesejo(String requisitante, Map cifraMensagem){
  
  // Separa o desejo e o destino
  Encrypted cifraDesejo = cifraMensagem.keys.first;
  Encrypted cifraDestinatario = cifraMensagem.values.first;

  // Recebe a chave do requisitante, e o utiliza no algoritmo
  String chave = chavesMestresCompartilhadas[requisitante];
  Criptografia criptografiaDoUsuario = new Criptografia(chave);

  // Decifra o desejo e o destinatario
  dynamic desejoClaro = criptografiaDoUsuario.descifrar(cifraDesejo, chave);
  String destinatarioClaro = criptografiaDoUsuario.descifrar(cifraDestinatario, chave);
  // Busca o desejo do requisitante, se encontrar no sistema o executa
  if (desejoClaro == "Solicito uma chave de sessão com"){
    chavesSessaoCompartilhadas = linkarChave(requisitante, destinatarioClaro);
  }else{
    print("Desejo não encontrado");
  }
}

// Linka uma chave de sessão com um usuário e um destinatário
Map linkarChave(String usuario, String destinatario){

  // Declara a sessão e gera uma chave
  Map<String,String> sessao = {usuario:destinatario};
  String chaveSessao = gerarChave();
  //Atualiza o sistema com a sessao e a chave
  Map<Map<String,String>, String> entrada = {sessao: chaveSessao};
  return entrada;
}

// Gera uma chave
String gerarChave(){
  var random = Random.secure();
  var values = List<int>.generate(32, (i) => random.nextInt(256));
  return base64Url.encode(values);

}