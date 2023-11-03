import { Injectable } from '@angular/core';
import { HashLocationStrategy } from '@angular/common';

//unused
@Injectable()
export class CustomLocationStrategy extends HashLocationStrategy {
    override prepareExternalUrl(internal: string): string {
        const token = window.location.search.substring(window.location.search.indexOf('=') + 1, window.location.search.length);
        sessionStorage.setItem('token', token);
        return window.location.search + super.prepareExternalUrl(internal);
    }
}
