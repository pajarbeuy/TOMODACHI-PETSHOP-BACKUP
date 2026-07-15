// scripts/audit_whitebox_metrics.js
/**
 * Script Audit Whitebox Metrics - ISO/IEC 25023 (MMo-2-S)
 * Memindai berkas source code PHP (backend/app) & Dart (frontend/lib),
 * menghitung McCabe Cyclomatic Complexity V(G) = P + 1,
 * dan menghasilkan statistik metrik MMo-2-S (Cyclomatic Complexity Adequacy).
 */

const fs = require('fs');
const path = require('path');

const BACKEND_PATH = path.join(__dirname, '..', 'backend', 'app');
const FRONTEND_PATH = path.join(__dirname, '..', 'frontend', 'lib');

// Ambang batas Cyclomatic Complexity standar ISO/IEC 25023
const CYCLOMATIC_THRESHOLD = 10;

function getAllFiles(dirPath, extensions, fileList = []) {
  if (!fs.existsSync(dirPath)) return fileList;
  const files = fs.readdirSync(dirPath);
  files.forEach((file) => {
    const filePath = path.join(dirPath, file);
    const stat = fs.statSync(filePath);
    if (stat.isDirectory()) {
      getAllFiles(filePath, extensions, fileList);
    } else {
      if (extensions.some(ext => file.endsWith(ext))) {
        fileList.push(filePath);
      }
    }
  });
  return fileList;
}

/**
 * Menghitung Cyclomatic Complexity sederhana untuk fungsi/metode dalam berkas
 * V(G) = P + 1 di mana P adalah jumlah predicate/decision keywords.
 */
function analyzeFileComplexity(filePath) {
  const content = fs.readFileSync(filePath, 'utf-8');
  const lines = content.split('\n');

  // Regex sederhana untuk mendeteksi awal fungsi/metode
  const functionRegex = /(function\s+\w+|class\s+\w+|void\s+\w+|\w+\s+\w+\(.*?\)\s*\{)/g;
  
  // Kata kunci penentu cabang logika (predicate nodes)
  const decisionRegex = /\b(if|else\s+if|elseif|for|foreach|while|case|catch|\?\?|\?)\b|&&|\|\|/g;

  const decisionsMatches = content.match(decisionRegex) || [];
  const decisionCount = decisionsMatches.length;

  // Total estimasi Cyclomatic Complexity berkas/modul
  const complexity = decisionCount + 1;

  return {
    filePath: path.relative(path.join(__dirname, '..'), filePath),
    lineCount: lines.length,
    decisionCount,
    complexity,
    isExceedingThreshold: complexity > CYCLOMATIC_THRESHOLD
  };
}

function runAudit() {
  console.log('====================================================');
  console.log('   AUDIT WHITEBOX METRICS - ISO/IEC 25023 (MMo-2-S) ');
  console.log('====================================================\n');

  const phpFiles = getAllFiles(BACKEND_PATH, ['.php']);
  const dartFiles = getAllFiles(FRONTEND_PATH, ['.dart']);

  const allFiles = [...phpFiles, ...dartFiles];
  console.log(`Menemukan ${phpFiles.length} berkas PHP dan ${dartFiles.length} berkas Dart (Total: ${allFiles.length} berkas).\n`);

  let totalModules = 0;
  let exceedingModules = 0;
  const results = [];

  allFiles.forEach((file) => {
    const analysis = analyzeFileComplexity(file);
    totalModules++;
    if (analysis.isExceedingThreshold) {
      exceedingModules++;
    }
    results.push(analysis);
  });

  // Perhitungan Formula Baku ISO/IEC 25023 MMo-2-S (Cyclomatic Complexity Adequacy)
  // X = 1 - (A / B)
  // A = Berkas/Modul yang melebihi threshold (>10)
  // B = Total Berkas/Modul yang dievaluasi
  const A = exceedingModules;
  const B = totalModules;
  const X_MMo = B > 0 ? (1 - (A / B)) : 1.0;
  const percentage = (X_MMo * 100).toFixed(2);

  console.log('--- RINGKASAN HASIL AUDIT METRIK ISO/IEC 25023 ---');
  console.log(`Total Modul/Berkas Evaluasi (B): ${B}`);
  console.log(`Modul Melebihi Threshold >10 (A) : ${A}`);
  console.log(`Skor Metrik MMo-2-S (X = 1 - A/B) : ${X_MMo.toFixed(4)} (${percentage}%)`);
  
  let status = 'Sangat Baik (Excellent)';
  if (percentage < 90 && percentage >= 75) status = 'Baik (Good)';
  else if (percentage < 75 && percentage >= 60) status = 'Cukup (Satisfactory)';
  else if (percentage < 60) status = 'Buruk (Unsatisfactory)';

  console.log(`Kategori Kualitas ISO 25023      : ${status}\n`);

  if (A > 0) {
    console.log('--- MODUL YANG MEMERLUKAN REFACTORING (V(G) > 10) ---');
    results
      .filter(r => r.isExceedingThreshold)
      .forEach(r => {
        console.log(`- [${r.filePath}] -> Complexity V(G): ${r.complexity} (Baris Kode: ${r.lineCount})`);
      });
  } else {
    console.log('Seluruh modul berada di bawah ambang batas Cyclomatic Complexity <= 10!');
  }

  console.log('\nAudit selesai successfully.');
}

runAudit();
