/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package cadastrobd.model;

/**
 *
 * @author Alaim
 */

// Classe PessoaFisica
public class PessoaFisica extends Pessoa {
    private String cpf;

    // Construtor padrão
    public PessoaFisica() {
    }

    // Construtor completo
    public PessoaFisica(int id, String nome, String logradouro, String cidade, String estado, String telefone, String email, String cpf) {
        super(id, nome, logradouro, cidade, estado, telefone, email);
        this.cpf = cpf;
    }
    
    //Getters e setters
    public String getCpf() {
        return cpf;
    }

    public void setCpf(String cpf) {
        this.cpf = cpf;
    }

    // Método para exibir os dados no console (reescrita)
    @Override
    public String toString() {
        return "Id: " + id + "\n" +
                "Nome: " + nome + "\n" +
                "Logradouro: " + logradouro + "\n" +
                "Cidade: " + cidade + "\n" +
                "Estado: " + estado + "\n" +
                "Telefone: " + telefone + "\n" +
                "E-mail: " + email + "\n" +
                "CPF: " + cpf + "\n";
    }   
}






