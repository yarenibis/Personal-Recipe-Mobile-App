# 🍴 Kişisel Yemek Tarifi Uygulaması

Bu proje, kullanıcıların kendi yemek tariflerini ekleyip, düzenleyip ve görüntüleyebildiği bir **mobil uygulamadır**.  
Kullanıcılar **şifre veya Google hesabı** ile giriş yapabilir, tariflerini yönetebilir ve fotoğraflarla destekleyebilir.  

---

## 📱 Uygulama Özellikleri

- 🔑 Kullanıcı Girişi: Email/şifre veya Google hesabı ile giriş  
- 📖 Tarifleri Görüntüleme: Kullanıcı kendi tariflerini ana ekranda görebilir  
- ➕ Yeni Tarif Ekleme: Fotoğraf ve açıklama ile tarif ekleme  
- ✏️ Tarif Düzenleme  
- ❌ Tarif Silme  
- ☁️ Firebase: Kullanıcı bilgileri, tarifler, fotoğraflar  

---

## 🗂️ Sayfalar

<h2>📸 Uygulama Ekran Görüntüleri</h2>

<table border="1" cellpadding="10" cellspacing="0">
  <thead>
    <tr>
      <th>Sayfa</th>
      <th>Görsel</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Giriş</td>
      <td>
        <img src="login.png" alt="Giriş" width="150">
        <img src="home.png" alt="Ana Ekran" width="150">
      </td>
    </tr>
    <tr>
      <td>Tarif Detay</td>
      <td>
        <img src="detail.png" alt="Tarif Detay" width="150">
        <img src="add_edit.png" alt="Tarif Ekle/Düzenle" width="150">
      </td>
    </tr>
  </tbody>
</table>


---

## 📸 Uygulama Ekran Görüntüleri (Markdown, yan yana)

**Giriş ve Ana Ekran:**  
<img src="images/login.png" alt="Giriş" width="200"> <img src="images/home.png" alt="Ana Ekran" width="200">  

**Tarif Detay ve Tarif Ekle/Düzenle:**  
<img src="images/detail.png" alt="Tarif Detay" width="200"> <img src="images/add_edit.png" alt="Tarif Ekle/Düzenle" width="200">  

> Görselleri `images/` klasörüne koymayı unutma.  

---

## 🔌 Firebase Entegrasyonu

- Authentication: Email/şifre ve Google giriş  
- Firestore: Tarifler ve kullanıcı bilgileri  
- Storage: Tarif fotoğrafları  

---

## 🚀 Kurulum ve Çalıştırma

```bash
git clone <repo-url>
cd <proje-klasörü>
flutter pub get
flutter run

