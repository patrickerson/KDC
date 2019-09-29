import 'package:encrypt/encrypt.dart';

class Criptografia{
String chave;
Key chaveAES;
IV iv;
Encrypter algoritimo;

Criptografia(this.chave){
  this.chaveAES = Key.fromBase64(chave); // Leitura da chave 
  this.iv = IV.fromLength(16); // Vetor inicial
  this.algoritimo = Encrypter(AES(chaveAES)); // Declara o algoritmo que será utilizado
}

// Recebe um texto claro e o cifra com uma chave
Encrypted cifrar(String texto, chave){

  // Texto
  String textoClaro = texto;

  //  Cifrar
  final encrypted = this.algoritimo.encrypt(textoClaro, iv: iv);
  

  // Retorna texto cifrado
  return encrypted;
}


// Recebe uma cifra e a descifra com uma chave
String descifrar(Encrypted cifra, String chave) {
  // Decifra
  String descriptografia = algoritimo.decrypt(cifra, iv: iv);

  // Retorna texto decifrado
  return descriptografia;
}

}