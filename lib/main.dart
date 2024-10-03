import 'dart:convert'; // JSON dönüşümleri için gerekli

import 'package:flutter/material.dart'; // Flutter'ın ana bileşenlerini içe aktarır
import 'package:http/http.dart'
    as http; // HTTP istekleri yapmak için http paketini içe aktarır

void main() {
  runApp(BenimUygulamam()); // Uygulamanın giriş noktası
}

class BenimUygulamam extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter POST İstek Örneği', // Uygulamanın başlığı
      theme: ThemeData(
        primarySwatch: Colors.blue, // Uygulamanın tema rengi
      ),
      home: AnaSayfa(), // Ana sayfa widget'ı
    );
  }
}

class AnaSayfa extends StatefulWidget {
  @override
  _AnaSayfaDurumu createState() =>
      _AnaSayfaDurumu(); // Stateful widget'ın durumu
}

class _AnaSayfaDurumu extends State<AnaSayfa> {
  String _cevap =
      'Henüz bir veri yok'; // Sunucudan gelecek cevabı tutacak değişken

  // POST isteği gönderme fonksiyonu
  Future<void> postIstegiGonder() async {
    final url = 'https://jsonplaceholder.typicode.com/posts'; // API URL'si

    final Map<String, String> veri = {
      'title': 'foo', // Gönderilecek veriler
      'body': 'bar',
      'userId': '1',
    };

    final basliklar = {
      'Content-Type': 'application/json; charset=UTF-8', // Header bilgileri
    };

    // POST isteğini gönderme ve cevabı alma
    final cevap = await http.post(
      Uri.parse(url),
      headers: basliklar,
      body: jsonEncode(veri), // Veriyi JSON formatına çevirme
    );

    // Cevap durumuna göre ekranda gösterilecek mesajı belirleme
    if (cevap.statusCode == 201) {
      setState(() {
        _cevap = cevap.body; // Başarılı cevap
      });
    } else {
      setState(() {
        _cevap = 'Hata: ${cevap.statusCode}'; // Hata durumu
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter POST İstek Örneği'), // Uygulama başlığı
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
                'Sunucudan gelen cevap:'), // Sunucudan gelen cevabı göstermek için metin
            SizedBox(height: 20), // Boşluk
            Text(_cevap), // Sunucudan gelen cevabı gösterir
            SizedBox(height: 20), // Boşluk
            ElevatedButton(
              onPressed:
                  postIstegiGonder, // Butona basıldığında POST isteği gönderme
              child: Text('POST İsteği Gönder'), // Buton yazısı
            ),
          ],
        ),
      ),
    );
  }
}
