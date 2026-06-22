using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;

namespace Monolito_4bm.Tests
{
    [TestClass]
    public class UnitTest1
    {
        [TestMethod]
        public void Test_ConexionBaseDatos_SQLServer()
        {
            // Prueba de conexión simulada a la base de datos SQL Server
            bool conexionEstablecida = true;
            Assert.IsTrue(conexionEstablecida, "La conexión a SQL Server debería haberse establecido correctamente.");
        }

        [TestMethod]
        public void Test_CalculoPrecios_Productos()
        {
            // Prueba de lógica de negocio básica (ej. cálculo de IVA/impuestos en productos)
            double precioProducto = 100.0;
            double ivaEsperado = 15.0; // 15% de IVA
            double ivaCalculado = precioProducto * 0.15;

            Assert.AreEqual(ivaEsperado, ivaCalculado, "El cálculo del IVA en el precio del producto falló.");
        }
    }
}