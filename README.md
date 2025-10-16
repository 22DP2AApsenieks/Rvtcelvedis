# 🏫 Rīgas RVT skolas izpētes spēle

Interaktīva 2D spēle, veidota ar **Godot Engine 4.5**, kurā spēlētājs var pārvietoties pa Rīgas RVT stāviem, aplūkot klases, skolotājus un priekšmetus, kā arī pārvietoties starp stāviem, izmantojot kāpnes un portālus.

---

##  Funkcijas

-  **Spēlētāja vadība** – kustība ar **WASD**, skata grozīšana ar **← / →** taustiņiem.
-  **Interaktīvas klases** – nospiežot **E**, var apskatīt:
  - Klases numuru un nosaukumu  
  - Skolotāju vārdus  
  - Priekšmetus  
  - Aprakstu un attēlu (ja pieejams)
-  **Stāvu maiņa** – pārvietošanās starp stāviem, izmantojot kāpnes vai portālus.
-  **Administratora panelis**  
  - Lietotāju un vērtējumu pārvaldība  
  - Klases pievienošana, rediģēšana un dzēšana
-  **Pauzes izvēlne** – **ESC** taustiņš aptur spēli, ļauj turpināt vai iziet.
-  **Interakcijas norāde** – parādās teksts, kad spēlētājs tuvojas objektiem, ar kuriem var mijiedarboties.

---

##  Kā palaist projektu

### 1️⃣ Variants – palaist Godot redaktorā (ieteicams)
1. Lejupielādē un uzstādi **[Godot Engine 4.5](https://godotengine.org/download)**.  
2. Lejupielādē šo repozitoriju vai tā ZIP failu un atarhivē to.  
3. Atver **Godot Engine**, izvēlies **“Import” → “Browse”** un atver failu **`project.godot`** no atarhivētās mapes.  
4. Kad projekts ir ielādēts, spied **▶️ Play** vai nospied **F5**, lai palaistu spēli.

---

### 2️⃣ Variants – palaist jau gatavu versiju (ja pieejama)
1. Ja repozitorijā ir mape **build/** vai **export/**, lejupielādē jaunāko versiju no sadaļas **Releases**.  
2. Atarhivē failu.  
3. Palaid izpildāmo failu (piemēram, `RVT_Spele.exe` Windows vidē).

---

##  Vadība

| Darbība | Taustiņš |
|----------|-----------|
| Kustība | **W / A / S / D** |
| Skriet | **Shift** |
| Mijiedarboties | **E** |
| Pagriezt kameru | **← / →** |
| Pauze | **ESC** |

---

## 📁 Mapju struktūra

├── Scenes/<br>
│ ├── Floors/ # Stāvu ainas (Floor1.tscn, Floor2.tscn, Floor3.tscn u.c.)<br>
│ ├── Classroom.tscn # Klases interaktīvā aina<br>
│ ├── AdminPanel.tscn # Administratora panelis<br>
│ ├── PauseMenu.tscn # Pauzes izvēlne<br>
│ └── Main.tscn # Galvenā spēles aina<br>
│<br>
├── Scripts/<br>
│ ├── Player.gd # Spēlētāja kustība un mijiedarbība<br>
│ ├── Classroom.gd # Klases informācijas loga loģika<br>
│ ├── Interactable.gd # Pamatklase interaktīviem objektiem<br>
│ ├── InteractHint.gd # Norāžu sistēma<br>
│ └── Main.gd # Galvenā spēles loģika (stāvu maiņa utt.)<br>
│<br>
├── Data/<br>
│ ├── users.json # Lietotāju datu bāze <br>
│ └── sessions.json # Sesiju dati<br>
│<br>
└── project.godot # Godot projekta fails<br>


---

## ⚙️ Prasības

- **Godot Engine:** versija 4.5 vai jaunāka  
- **GPU:** jebkurš ar OpenGL 3.3+ atbalstu  
- **Operētājsistēma:** Windows / Linux / macOS  

---

##  Autori

**Tomass Siliņš ,Ādams Apšenieks, Ralfs Pētersons, Matīss Savickis, Aleksis Virvinskis**  
Grupa: **DP4-2**  
Rīgas Valsts tehnikums (RVT)

---

##  Licence

Šis projekts izstrādāts **izglītojošiem mērķiem**.  
Atļauts skatīt, labot un kopīgot **nekomerciālos nolūkos**, norādot autoru.

---

##  Piezīmes

- Kad augšupielādē projektu GitHub, pārliecinies, ka **`project.godot`** fails atrodas mapes saknē.  
- JSON faili (`users.json`, `sessions.json` u.c.) sākotnēji var būt tukši – tie tiks aizpildīti automātiski, kad spēle tiks palaista pirmo reizi.

---
