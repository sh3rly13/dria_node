#!/bin/bash
cat << "EOF"
   ██████╗██╗  ██╗██████╗ ██████╗ ██╗     ██╗   ██╗
  ██╔════╝██║  ██║╚════██╗██╔══██╗██║     ╚██╗ ██╔╝
  ╚█████╗ ███████║ █████╔╝██████╔╝██║      ╚████╔╝ 
   ╚═══██╗██╔══██║ ╚═══██╗██╔══██╗██║       ╚██╔╝  
  ██████╔╝██║  ██║██████╔╝██║  ██║███████╗   ██║   
  ╚═════╝ ╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚══════╝   ╚═╝   
EOF
echo "Ollama, Gemma3 ve DRIA Düğümü için otomatik kurulum başlatılıyor..."


echo -e "\n--- Adım 1: Homebrew kontrol ediliyor ve gerekiyorsa kuruluyor ---"


if ! command -v brew &> /dev/null
then
    echo "Homebrew bulunamadı. Kuruluma devam etmek için Homebrew kuruluyor..."
    echo "Sizden yönetici şifreniz istenebilir."

    
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    
    if [ $? -ne 0 ]; then
        echo -e "\n--- HATA: Homebrew kurulumu başarısız oldu. ---"
        echo "Lütfen **Terminali yeniden başlatın ve bu betiği tekrar çalıştırın**."
        exit 1
    fi

    echo "Homebrew başarıyla kuruldu. Ortam değişkenleri güncelleniyor..."
    
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"

    if ! command -v brew &> /dev/null; then
        echo -e "\n--- HATA: Homebrew PATH'e eklenemedi. ---"
        echo "Lütfen **Terminali yeniden başlatın ve bu betiği tekrar çalıştırın**."
        exit 1
    fi
    echo "Homebrew kurulumu tamamlandı."
else
    echo "Homebrew zaten yüklü. Devam ediliyor."
fi

echo -e "\n--- Adım 2: Ollama kuruluyor ve Gemma3 modeli indiriliyor ---"

echo "Ollama Homebrew üzerinden kuruluyor..."
if brew install ollama; then
    echo "Ollama başarıyla kuruldu."
else
    echo -e "\n--- HATA: Ollama kurulumu başarısız oldu. ---"
    echo "Lütfen **Terminali yeniden başlatın ve bu betiği tekrar çalıştırın**."
    exit 1
fi


ollama serve & > /dev/null 2>&1
OLLAMA_PID=$! # Ollama sürecinin PID'sini sakla
sleep 5 # Kısa bir bekleme, Ollama servisinin başlaması için

download_gemma3() {
    echo "Gemma3 modeli indiriliyor. İnternet hızınıza bağlı olarak bu biraz zaman alabilir."
    if ollama pull gemma3; then
        echo "Gemma3 modeli başarıyla indirildi ve hazır."
        return 0 # Başarılı
    else
        return 1 # Başarısız
    fi
}

if download_gemma3; then
    true
else
    # İlk deneme başarısız oldu, hata türünü kontrol et
    # Hatanın DNS ile ilgili olup olmadığını tahmin etmek için basit bir kontrol
    # Ollama'nın hata çıktısı doğrudan DNS hatasını belirtmeyebilir,
    # bu yüzden genel bir ağ hatası olarak kabul edeceğiz.
    echo -e "\n--- UYARI: Gemma3 modeli indirilirken bir sorun oluştu. Büyük ihtimalle bir ağ veya DNS hatası. ---"
    echo "Çok fazla deneme yapmak zorunda kaldık, lütfen DNS ayarlarınızı kontrol edin."

    # DNS önbelleğini temizle
    echo "DNS önbelleği temizleniyor..."
    sudo dscacheutil -flushcache
    sudo killall -HUP mDNSResponder
    echo "DNS önbelleği temizlendi. Şimdi tekrar denenecek."

    # İkinci deneme
    if download_gemma3; then
        true 
    else
        echo -e "\n--- HATA: Gemma3 modeli ikinci denemede de indirilemedi. ---"
        echo "Lütfen **DNS ayarlarınızı değiştirip** (örn: Google DNS 8.8.8.8 / 8.8.4.4 veya Cloudflare DNS 1.1.1.1) ve **Terminali yeniden başlatıp tekrar deneyin**."
        kill $OLLAMA_PID # Ollama servisini durdur
        exit 1
    fi
fi

kill $OLLAMA_PID # Ollama servisini durdur


echo -e "\n--- Adım 3: DRIA Düğümü kuruluyor ---"


echo "Dria Compute Başlatıcı indiriliyor ve kuruluyor..."
if curl -fsSL https://dria.co/launcher | bash; then
    echo "Dria Compute Başlatıcı başarıyla kuruldu."
else
    echo -e "\n--- HATA: Dria Compute Başlatıcı kurulumu başarısız oldu. ---"
    echo "Lütfen **Terminali yeniden başlatın ve bu betiği tekrar çalıştırın**."
    exit 1
fi

echo "dkn-compute-launcher için macOS güvenlik uyarısı atlanmaya çalışılıyor (varsa)..."
if xattr -d com.apple.quarantine dkn-compute-launcher 2>/dev/null; then
    echo "Güvenlik karantina özelliği kaldırıldı (eğer uygulanabildiyse)."
else
    echo "Güvenlik karantina özelliği kaldırılamadı veya gerekli değildi. Devam ediliyor."
fi


echo "DRIA NODE başlatılıyor. İlk çalıştırmada node bilgileri (wallet private key, modeller) sağlamanız istenecektir."
echo "Lütfen modeller kısmında gemma3:4b modelini seçin. Diğer modeller yüksek bellek tüketimi olabilir ve kurulumda sorun yaşayabilirsiniz"
sleep 5

if command -v dkn-compute-launcher &> /dev/null; then
    dkn-compute-launcher start
elif [ -f "./dkn-compute-launcher" ]; then
    ./dkn-compute-launcher start
else
    echo -e "\n--- HATA: 'dkn-compute-launcher' bulunamadı veya çalıştırılamadı. ---"
    echo "DRIA kurulumunu manuel olarak tamamlamanız gerekebilir."
    echo "Lütfen **Terminali yeniden başlatın ve bu betiği tekrar çalıştırın** veya Dria dokümantasyonunu kontrol edin."
    exit 1
fi

cat << "EOF"
   ██████╗██╗  ██╗██████╗ ██████╗ ██╗     ██╗   ██╗
  ██╔════╝██║  ██║╚════██╗██╔══██╗██║     ╚██╗ ██╔╝
  ╚█████╗ ███████║ █████╔╝██████╔╝██║      ╚████╔╝ 
   ╚═══██╗██╔══██║ ╚═══██╗██╔══██╗██║       ╚██╔╝  
  ██████╔╝██║  ██║██████╔╝██║  ██║███████╗   ██║   
  ╚═════╝ ╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚══════╝   ╚═╝   
EOF

echo -e "\nKurulum tamamlandı!"
echo "Gemma3 modeli gözükmez ise önce --> ollama pull gemma3:4b <-- komutunu ardından --> dkn-compute-launcher setup <-- komutunu çalıştırın" 
echo "Model seçiminin gemma3:4b olduğundan emin olup kuruluma devam edin. Hata yaşamanız durumunda X : @sh3rly13 üzerinden iletişime geçebilirsiniz"
sleep 3
