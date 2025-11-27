# Secuirrel - saltstack for SecOps

Tämä projekti sisältää SaltStack-konfiguraation (states), jonka avulla voidaan nopeasti ja toistettavasti pystyttää Kali Linux -asennus CTF (Capture The Flag) -käyttöön. Tavoitteena on vähentää manuaalista työtä ja varmistaa, että kaikilla on johdonmukainen ja toimiva työympäristö.

Koko konfiguraatio on versiohallinnassa, joten muutoksia on helppo seurata ja palata aiempiin versioihin.

## Tavoitteet ja Ominaisuudet

Projektin päätavoitteena on luoda joustava ja automatisoitu tapa konfiguroida CTF-koneita.

*   **🚀 Nopea käyttöönotto:** Uusi, puhdas Kali-kone saadaan käyttövalmiiksi yhdellä komennolla.
*   **🔁 Toistettavuus:** Jokainen asennus on identtinen, mikä poistaa "toimii minun koneellani" -ongelmat.
*   **🛠️ Modulaarisuus:** Perustyökalut, käyttäjäkohtaiset työkalut ja monimutkaisemmat asennukset on eroteltu omiin tiedostoihinsa.
*   **👥 Käyttäjäprofiilit:** Mahdollisuus asentaa eri työkaluja eri käyttäjille (esim. "Henry" ja "Ilja") heidän tarpeidensa mukaan.
*   **✅ Idempotenssi:** Salt-ajon voi suorittaa useita kertoja peräkkäin. Vain tarvittavat muutokset tehdään - mitään ei hajoa.
*   **🔧 Keskitetty työkaluhallinta:**
    TBD

## Projektin Rakenne

```
ctf-kali-salt/
├── salt/
│   ├── top.sls             # Pääohjaustiedosto, määrittää mitä ajetaan
│   └── ctf_box/
│       ├── init.sls        # Orkestroi kaikki ctf_box-tilat (states)
│       ├── tools.sls       # Perustyökalut (apt)
│       ├── binwalk.sls     # Binwalk v2 & v3 asennus
│       ├── ghidra.sls      # Ghidran asennus
│       └── users/          # Käyttäjäkohtaiset profiilit
│           ├── henry.sls
│           └── ilja.sls
└── README.md
```

## Käyttöönotto

Nämä ohjeet on tarkoitettu ajettavaksi suoraan kohdekoneella (masterless-tilassa).

### 1. Vaatimukset

*   Puhdas Kali Linux -asennus.
*   `git` ja `salt-minion` asennettuna.

Voit asentaa tarvittavat paketit komennolla:
```bash
sudo apt update
sudo apt install -y git salt-minion
```

### 2. Projektin kloonaus

Kloonaa tämä repositorio koneellesi:
```bash
git clone <sinun-git-repo-osoite>
cd ctf-kali-salt
```

### 3. Konfiguraation ajaminen

Siirry projektin juurihakemistoon (`ctf-kali-salt/`) ja suorita `salt-call`.

#### A) Vain perusasennus

Tämä asentaa kaikki `tools.sls`, `binwalk.sls` ja `ghidra.sls` -tiedostoissa määritellyt asiat, mutta ei käyttäjäkohtaisia työkaluja.

```bash
sudo salt-call --local --file-root=./salt state.apply
```

#### B) Perusasennus + käyttäjän työkalut

Tämä asentaa peruspaketin lisäksi `users/käyttäjä.sls`-tiedostossa määritellyt työkalut.

```bash
sudo salt-call --local --file-root=./salt state.apply pillar='{"user_profile": "käyttäjä"}'
```

---

## Roadmap & Toteutuksen Tilanne (Checklist)

- [x] **Salt-perusrakenne:** Modulaarinen rakenne `top.sls`- ja `init.sls`-tiedostoilla.
- [ ] **Perustyökalut:** Yleisten työkalujen (nmap, gobuster, seclists, jne.) asennus `apt`:lla.
- [ ] **Binwalk v2 & v3:** Kaksi versiota asennettu rinnakkain omiin virtuaaliympäristöihinsä (`binwalk2` & `binwalk3`).
- [ ] **Ghidra:** Uusimman version automaattinen lataus, purku ja asennus.
- [ ] **Käyttäjäprofiilit:** Joustava systeemi esun Henryn ja Iljan työkalulistojen asentaminen saltin `pillar`-datan avulla.
- [ ] **Dotfiles-hallinta:** Omien konfiguraatiotiedostojen (esim. `.zshrc`, `.vimrc`, `.tmux.conf`) automaattinen kopiointi käyttäjän kotihakemistoon.
- [ ] **Työkalujen asennus Gitistä:** Tuki työkalujen kloonaamiselle suoraan Git-repositorioista (esim. `/opt`-hakemistoon).
- [ ] **Salaisuuksien hallinta (Secrets Management):** Tapa hallita turvallisesti API-avaimia tai lisenssejä (esim. Saltin GPG-renderöijällä).

## Laajentaminen

Projektia on helppo laajentaa.

*   **Lisää yleinen työkalu:** Lisää paketin nimi `pkgs`-listaan tiedostossa `salt/ctf_box/tools.sls`.
*   **Lisää uusi käyttäjä ("Anna"):**
    1.  Luo uusi tiedosto `salt/ctf_box/users/anna.sls`.
    2.  Määrittele Annan työkalut tiedostoon samaan tapaan kuin Henryllä tai Iljalla.
    3.  Lisää `salt/ctf_box/init.sls`-tiedostoon uusi ehto:
        ```yaml
        {% elif user == 'anna' %}
        include:
          - ctf_box.users.anna
        ```
