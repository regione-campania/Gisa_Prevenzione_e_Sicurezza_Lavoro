import { TableExport } from 'tableexport';
import { SheetApi } from './lib';
import * as XLSX from 'xlsx';

export class Utils {
  static showSpinner(show: boolean, text?: string) {
    if (show) {
      document.getElementById('spinner')!.style.display = 'block';
      if (text)
        document.getElementById('spinner-label')!.innerHTML = text!.toString();
    } else {
      document.getElementById('spinner')!.style.display = 'none';
      document.getElementById('spinner-label')!.innerHTML = '';
    }
  }

  static min(args: any[]) {
    if (!args || args.length === 0) return undefined;
    let min = args[0];
    if (args.length <= 1) return min;
    args.forEach((el: any) => {
      if (el < min) min = el;
    });
    return min;
  }

  static max(args: any[]) {
    if (!args || args.length === 0) return undefined;
    let max = args[0];
    if (args.length <= 1) return max;
    args.forEach((el: any) => {
      if (el > max) max = el;
    });
    return max;
  }

  static sort(args: any[]) {
    let temp = [];
    let m;
    const len = args.length;
    for (let i = 0; i < len; i++) {
      m = Utils.min(args);
      temp.push(m);
      args.splice(args.indexOf(m), 1);
    }
    return temp;
  }

  static download(data: any, fileName?: string) {
    //data = data.slice(0, data.size, "text/xml") //forzo text per forzare download e non apertura
    const url = URL.createObjectURL(data);
    const a = document.createElement('a');
    a.href = url;
    a.download = fileName ?? '';
    a.click();
    setTimeout(function () {
      a.remove();
      URL.revokeObjectURL(url);
    }, 100);
  }

  static exportXlsxWithSheetJs(sheets: SheetApi[], filename?: string) {
    if (!filename) {
      let now = new Date();
      filename = `export_${now.getFullYear()}-${(now.getMonth() + 1).toString().padStart(2, '0')}-${now.getDate().toString().padStart(2, '0')}`;
    }
    let workbook = XLSX.utils.book_new();
    for (let sheet of sheets) {
      let worksheet = XLSX.utils.aoa_to_sheet([
        Array.from(sheet.intestazione_colonne),
      ]);
      XLSX.utils.sheet_add_aoa(worksheet, sheet.dati, { origin: 'A2' });
      //calculating widths
      let widths = sheet.intestazione_colonne.map(el => el.length);
      for(let row of sheet.dati) {
        for(let i = 0; i < row.length; i++) {
          if((row[i] ?? '').toString().length > widths[i])
            widths[i] = row[i].toString().length;
        }
      }
      worksheet['!cols'] = [];
      for(let i = 0; i < widths.length; i++)
        worksheet['!cols'][i] = { wch: widths[i]}
      XLSX.utils.book_append_sheet(workbook, worksheet, sheet.nome_foglio);
    }
    XLSX.writeFile(workbook, `${filename}.xlsx`);
  }

  static importXlsxWithSheetJS(file: File): Promise<XLSX.WorkBook> {
    return new Promise((resolve, reject) => {
      let reader = new FileReader();
      reader.onload = function(e) {
        let workbook = XLSX.read(e.target?.result);
        resolve(workbook);
      }
      reader.onerror = function() {
        reject('FILE READ ERROR');
      }
      reader.readAsArrayBuffer(file);
    })
  }

  static exportHTML(
    html: HTMLElement | string,
    mimeType: string = 'text/plain',
    fileName?: string
  ) {
    const encodedData = encodeURI(
      typeof html === 'object' ? html.outerHTML : html
    );
    const a = document.createElement('a');
    a.href = `data:${mimeType}, ${encodedData}`;
    a.download = fileName ?? 'export.txt';
    a.click();
    setTimeout(() => {
      a.remove();
    }, 0);
  }

  static exportTable(
    table: HTMLTableElement,
    options?: {
      filename?: string;
      predicate?: (el: HTMLTableRowElement) => boolean;
      skipColumns?: Array<number>;
    }
  ) {
    console.log('r');
    let t = document.createElement('table');
    let tHead, tBody, tFoot: HTMLTableSectionElement;
    if (table.tHead) {
      tHead = t.createTHead();
      extractSection(table.tHead, tHead);
      let temp: any;
      tHead.querySelectorAll('td').forEach((td) => {
        temp = document.createElement('th');
        temp.innerText = td.innerText;
        temp.style.border = '1px solid black';
        td.replaceWith(temp);
      });
    }
    if (table.tBodies[0]) {
      tBody = t.createTBody();
      extractSection(table.tBodies[0], tBody);
    }
    if (table.tFoot) {
      tFoot = t.createTFoot();
      extractSection(table.tFoot, tFoot);
    }

    let filename = options?.filename;
    if (!filename) {
      const now = new Date();
      filename =
        'report-' +
        (now.getDate() < 10 ? '0' + now.getDate() : now.getDate()) +
        '_' +
        (now.getMonth() < 10
          ? '0' + (now.getMonth() + 1)
          : now.getMonth() + 1) +
        '_' +
        now.getFullYear() +
        '-' +
        now.getHours() +
        '_' +
        now.getMinutes() +
        '.xls';
    }

    this.exportHTML(t, 'application/vnd.ms-excel', filename);

    //helper
    function extractSection(
      source: HTMLTableSectionElement,
      target: HTMLTableSectionElement
    ) {
      let tempRow: HTMLTableRowElement;
      let tempCell: HTMLTableCellElement;
      Array.from(source.rows).forEach((r) => {
        if (options?.predicate && !options.predicate(r)) return;
        tempRow = target.insertRow();
        if (r.cells) {
          Array.from(r.cells).forEach((c) => {
            if (options?.skipColumns?.includes(c.cellIndex)) return;
            tempCell = tempRow.insertCell();
            tempCell.innerText = c.innerText;
            tempCell.style.border = '1px solid black';
          });
        }
      });
    }
  }

  static fromISOTimeToLocaleTime(s: string) {
    if (s == null) return null;
    let dateString = s.split('T'); //isolo data da orario
    let splitted = dateString[0].split('-');
    dateString[1] = dateString[1].split('.')[0]; //rimuovo millisecondi da orario;
    return `${splitted[2]}-${splitted[1]}-${splitted[0]} ${dateString[1]}`;
  }

  static fromISOTimeToLocaleDate(s: string) {
    if (s == null) return null;
    let dateString = s.split('T'); //isolo data da orario
    let splitted = dateString[0].split('-');
    return `${splitted[2]}-${splitted[1]}-${splitted[0]}`;
  }

  static fromISODateToLocaleDate(s: string) {
    if (s == null) return null;
    let splitted = s.split('-');
    return `${splitted[2]}-${splitted[1]}-${splitted[0]}`;
  }

  static getLocation() {
    return new Promise((res, rej) => {
      navigator.geolocation.getCurrentPosition(res, rej);
    });
  }

  static tableExportXlsx(
    table: HTMLTableElement,
    options?: {
      filename?: string;
      predicate?: (el: HTMLTableRowElement) => boolean;
      skipColumns?: Array<number>;
    },
    _extension?: string
  ) {
    Utils.showSpinner(true, 'Creazione report in corso');
    let t = document.createElement('table');
    t.classList.add('table');
    t.classList.add('table-bordered');
    let tHead, tBody, tFoot: HTMLTableSectionElement;

    if (table.tHead) {
      tHead = t.createTHead();
      extractSection(table.tHead, tHead);
      let temp: any;
      tHead.querySelectorAll('td').forEach((td) => {
        temp = document.createElement('th');
        temp.innerText = td.innerText;
        temp.style.border = '1px solid black';
        td.replaceWith(temp);
      });
    }
    if (table.tBodies[0]) {
      tBody = t.createTBody();
      extractSection(table.tBodies[0], tBody);
    }
    if (table.tFoot) {
      tFoot = t.createTFoot();
      extractSection(table.tFoot, tFoot);
    }

    let filename = options?.filename;
    if (!filename) {
      const now = new Date();
      filename =
        'report-' +
        (now.getDate() < 10 ? '0' + now.getDate() : now.getDate()) +
        '_' +
        (now.getMonth() < 10
          ? '0' + (now.getMonth() + 1)
          : now.getMonth() + 1) +
        '_' +
        now.getFullYear() +
        '-' +
        now.getHours() +
        '_' +
        now.getMinutes();
      //+ '.xls'
    }

    /* var istance = new TableExport(t, {
      headers: true, // (Boolean), display table headers (th or td elements) in the <thead>, (default: true)
      footers: true, // (Boolean), display table footers (th or td elements) in the <tfoot>, (default: false)
      formats: [`${_extension}`], // (String[]), filetype(s) for the export, (default: ['xlsx', 'csv', 'txt'])
      filename: filename, // (id, String), filename for the downloaded file, (default: 'id')
      bootstrap: true, // (Boolean), style buttons using bootstrap, (default: true)
      position: 'bottom', // (top, bottom), position of the caption element relative to table, (default: 'bottom')
      //ignoreRows: null,                           // (Number, Number[]), row indices to exclude from the exported file(s) (default: null)
      //ignoreCols: null,                           // (Number, Number[]), column indices to exclude from the exported file(s) (default: null)
      trimWhitespace: true, // (Boolean), remove all leading/trailing newlines, spaces, and tabs from cell text in the exported file(s) (default: false)
    }); */

    /* var exportData: any = istance.getExportData();
    var key = Object.keys(exportData)[0];
    istance.export2file(
      exportData[key][`${_extension}`].data,
      exportData[key][`${_extension}`].mimeType,
      exportData[key][`${_extension}`].filename,
      '.'+_extension
    ); */
    Utils.showSpinner(false);

    //helper
    function extractSection(
      source: HTMLTableSectionElement,
      target: HTMLTableSectionElement
    ) {
      let tempRow: HTMLTableRowElement;
      let tempCell: HTMLTableCellElement;
      Array.from(source.rows).forEach((r) => {
        if (options?.predicate && !options.predicate(r)) return;
        tempRow = target.insertRow();
        if (r.cells) {
          Array.from(r.cells).forEach((c) => {
            if (options?.skipColumns?.includes(c.cellIndex)) return;
            tempCell = tempRow.insertCell();
            tempCell.innerText = c.innerText;
            tempCell.style.border = '1px solid black';
            tempCell.classList.add('tableexport-string');
          });
        }
      });
    }
  }

  static trimData(obj: any) {
    if (obj && typeof obj === 'object') {
      Object.keys(obj).map((key) => {
        if (typeof obj[key] === 'object') {
          this.trimData(obj[key]);
        } else if (typeof obj[key] === 'string') {
          obj[key] = obj[key].trim();
        }
      });
    }
    return obj;
  }
}
