using System;
using System.Security.Cryptography;
using System.Text;

namespace Capa_Negocio.SimpleCryptoShim
{
    public interface ICryptoService
    {
        string GenerateSalt();
        string Compute(string plain, string salt);
    }

    public class PBKDF2 : ICryptoService
    {
        private const int SaltSize = 16; // 128 bit
        private const int HashSize = 32; // 256 bit
        private const int Iterations = 10000;

        public string GenerateSalt()
        {
            var salt = new byte[SaltSize];
            using (var rng = RandomNumberGenerator.Create())
            {
                rng.GetBytes(salt);
            }
            return Convert.ToBase64String(salt);
        }

        public string Compute(string plain, string salt)
        {
            if (plain == null) throw new ArgumentNullException(nameof(plain));
            if (salt == null) throw new ArgumentNullException(nameof(salt));

            // Accept either 'salt' or 'salt.hash' as the second parameter.
            string saltOnly = salt;
            if (salt.Contains("."))
            {
                var parts = salt.Split(new[] { '.' }, 2);
                saltOnly = parts[0];
            }

            byte[] saltBytes;
            try
            {
                saltBytes = Convert.FromBase64String(saltOnly);
            }
            catch (FormatException fe)
            {
                throw new FormatException("El valor de salt no es una cadena Base64 válida.", fe);
            }
            using (var pbkdf2 = new Rfc2898DeriveBytes(plain, saltBytes, Iterations, HashAlgorithmName.SHA256))
            {
                var hash = pbkdf2.GetBytes(HashSize);
                string hashB64 = Convert.ToBase64String(hash);
                // Return combined format 'salt.hash' so existing comparisons (stored == Compute(...)) succeed
                return saltOnly + "." + hashB64;
            }
        }
    }
}
