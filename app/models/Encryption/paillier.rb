require 'openssl'
module Encryption
  class Paillier

    def self.encrypt(m, election)
      bit_length = election.bit_length.to_i.to_bn
      nsquare = election.nsquare.to_i.to_bn
      n = election.n.to_i.to_bn
      g = election.g.to_i.to_bn

      r = OpenSSL::BN::generate_prime(bit_length)
      g.mod_exp(m, nsquare)*(r.mod_exp(n, nsquare))%(nsquare)
    end

    def self.decrypt(c, election)
      g = election.g.to_i.to_bn
      lambda = election.lambda.to_i.to_bn
      nsquare = election.nsquare.to_i.to_bn
      n = election.n.to_i.to_bn
      c = c.to_i.to_bn
      u = ((g.mod_exp(lambda, nsquare) - 1)/(n))[0].mod_inverse(n)
      return (((c.mod_exp(lambda, nsquare) - 1)/n)[0]*u)%n
    end

    def self.add_encrypted_vote(e1, e2, election)
      e1.to_i.to_bn*e2.to_i.to_bn%(election.nsquare.to_i.to_bn)
    end

    def self.key_generation(bit_length_value)
      p = OpenSSL::BN::generate_prime(bit_length_value)
      q = OpenSSL::BN::generate_prime(bit_length_value)
      n = p*q
      nsquare = n*n
      lambda = ((p-1)*(q-1)/(p-1).gcd(q-1))[0]
      g = 2.to_bn
      if (((g.mod_exp(lambda,nsquare)-1)/(n))[0].gcd(n).to_i != 1)
        puts "g is not good. Choose g again."
      else
        return {g: g, n: n, nsquare: nsquare, lambda: lambda, bit_length: bit_length_value}
      end
    end
  end
end