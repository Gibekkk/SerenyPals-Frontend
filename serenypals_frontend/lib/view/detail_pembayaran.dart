import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: PaymentScreen()));

const color3 = Color(0xFFBDDDE4);
const color4 = Color(0xFFFFF1D5);

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 10), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PaymentSuccessScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color4,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Pembayaran', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Image.asset('assets/qris_dummy.png', height: 200),
            SizedBox(height: 10),
            Text('NMID: IDXXXXXXX', style: TextStyle(color: Colors.grey)),
            Text('Kode berlaku 10:00', style: TextStyle(color: Colors.orange)),
            SizedBox(height: 10),
            Icon(Icons.refresh, color: Colors.black),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color3,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Jumlah', style: TextStyle(fontSize: 16)),
                      Text('Total', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('389 Diamond', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('Rp 118.000', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text('Mendapatkan 10 koin', style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0))),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentSuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color4,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 80),
            SizedBox(height: 10),
            Text(
              'Pembayaran berhasil',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            SizedBox(height: 10),
            Text(
              'Rp 118.000',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Detail transaksi', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 10),
            _buildDetailRow('ID transaksi', '001'),
            _buildDetailRow('Metode Pembayaran', 'BCA Mobile'),
            _buildDetailRow('Status', 'Berhasil'),
            _buildDetailRow('Tanggal', '28 Mar 2025'),
            _buildDetailRow('Waktu', '08:05'),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color3,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildPaymentInfoRow('SerenyShop 388 Diamond', 'Rp 116.000'),
                  _buildPaymentInfoRow('Biaya Admin', 'Rp 2.000'),
                  _buildPaymentInfoRow('Total Pembayaran', 'Rp 118.000', isBold: true),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text('Done'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: Colors.grey[700])),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPaymentInfoRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          ),
          Text(
            value,
            style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
