import 'package:encrypt/encrypt.dart';

import 'KDC.dart';
import 'AES.dart';

class Usuario{

  /* A classe usuário possui os seguintes atributos:

  Nome
  Chave Mestre
  Chave de Sessão
  Criptografia com a chave mestre
  Criptogrgafia com a chave de sessão

  */

  String nome;
  String chaveMestre;
  var chaveSessao;
  Criptografia criptografia;
  Criptografia criptografiaDeSessao;


  /* Construtor do usuário

  Com o nome, gera as seguintes instâncias:

  chave mestre
  criptografia com a chave mestre
  */
  Usuario(this.nome){
    this.chaveMestre = chavesMestresCompartilhadas[this.nome];
    this.criptografia = Criptografia(chaveMestre);
  }


  /* Gera um mapeamento, com a estrutura: (Desejo do usuário): (Destinatario)

  O desejo do usuário é um comando que é criptografado para o KDC
  O destinatario poderia ser um banco de dados ou um sistema quaisquer.

  */

  dynamic solicitarChaveSessao(Usuario nomeDoDestinatario, String chave){
    // Finaliza o processo, e printa que a operação foi negada
    if (chave != chaveMestre){
      return "Operação negada!";

    }else{

      Encrypted desejo = criptografia.cifrar("Solicito uma chave de sessão com", chave); // Cifra o desejo
      Encrypted destinatarioCifrado = criptografia.cifrar(nomeDoDestinatario.nome, chave); // Cifra o destino 
      
      Map cifraUsuarioDestinatario = {desejo: destinatarioCifrado}; // Mapeia o desejo e o destino

      return cifraUsuarioDestinatario; // retorna uma cifra contendo o desejo e o destino
    }
  }

  // Atualiza a chave de sessão
  void receberChaveSessao(Map<String, String> sessao){
    this.chaveSessao = chavesSessaoCompartilhadas.values.first;

    this.criptografiaDeSessao = new Criptografia(this.chaveSessao);
  }

  // Retorna uma mensagem criptografada com a chave de sessão
  Encrypted enviarMensagem(String mensagem){
    Encrypted mensagemCifrada = criptografiaDeSessao.cifrar(mensagem, this.chaveSessao);
    return mensagemCifrada;
  }

  // Recebe uma mensagem criptografada da sessão e a retorna descriptografada
  String receberMensagem(Encrypted mensagemCifrada){
    String mensagemDecifrada = criptografiaDeSessao.descifrar(mensagemCifrada, this.chaveSessao);
    return mensagemDecifrada;
  }
}