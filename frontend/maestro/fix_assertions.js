const fs = require('fs');
const path = require('path');

const dir = __dirname;
const files = fs.readdirSync(dir).filter(f => f.endsWith('.yaml'));

const replacements = {
    '"POS"': '".*POS.*"',
    '"Produk"': '".*Produk.*"',
    '"Kategori"': '".*Kategori.*"',
    '"Dasbor"': '".*Dasbor.*"',
    '"Akun"': '".*Akun.*"',
    '"AI"': '".*AI.*"',
    '"Riwayat"': '".*Riwayat.*"',
    '"TOMODACHI PETSHOP"': '".*TOMODACHI PETSHOP.*"',
    '"TOMODACHI"': '".*TOMODACHI.*"',
    '"Tomodachi"': '".*Tomodachi.*"',
    '"Admin"': '".*Admin.*"',
    '"Kasir"': '".*Kasir.*"',
    '"Owner"': '".*Owner.*"'
};

for (const file of files) {
    const filePath = path.join(dir, file);
    let content = fs.readFileSync(filePath, 'utf8');
    let changed = false;

    for (const [key, value] of Object.entries(replacements)) {
        // Regex to match exact assertVisible: "XXX"
        const regex = new RegExp(`assertVisible:\\s*${key}`, 'g');
        if (regex.test(content)) {
            content = content.replace(regex, `assertVisible: ${value}`);
            changed = true;
        }
    }

    if (changed) {
        fs.writeFileSync(filePath, content, 'utf8');
        console.log(`Updated assertions in ${file}`);
    }
}
