import { TableExport } from 'tableexport';
import { Utils } from './utils/utils.class';

export class Export {

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

        var istance = new TableExport(t, {
            headers: true, // (Boolean), display table headers (th or td elements) in the <thead>, (default: true)
            footers: true, // (Boolean), display table footers (th or td elements) in the <tfoot>, (default: false)
            formats: [`${_extension}`], // (String[]), filetype(s) for the export, (default: ['xlsx', 'csv', 'txt'])
            filename: filename, // (id, String), filename for the downloaded file, (default: 'id')
            bootstrap: true, // (Boolean), style buttons using bootstrap, (default: true)
            position: 'bottom', // (top, bottom), position of the caption element relative to table, (default: 'bottom')
            //ignoreRows: null,                           // (Number, Number[]), row indices to exclude from the exported file(s) (default: null)
            //ignoreCols: null,                           // (Number, Number[]), column indices to exclude from the exported file(s) (default: null)
            trimWhitespace: true, // (Boolean), remove all leading/trailing newlines, spaces, and tabs from cell text in the exported file(s) (default: false)
        });

        var exportData: any = istance.getExportData();
        var key = Object.keys(exportData)[0];
        istance.export2file(
            exportData[key][`${_extension}`].data,
            exportData[key][`${_extension}`].mimeType,
            exportData[key][`${_extension}`].filename,
            '.' + _extension
        );
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
}