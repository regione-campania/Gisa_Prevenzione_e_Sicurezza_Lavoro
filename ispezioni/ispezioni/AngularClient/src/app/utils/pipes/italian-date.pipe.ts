import { Pipe, PipeTransform } from "@angular/core";

@Pipe({ name: 'italianDate'})
export class ItalianDatePipe implements PipeTransform {

  transform(value: string, ...args: any[]) {
    if(!value) return '';
    const date = new Date(value);
    if(value.toString() === 'Invalid Date') return value;
    else return (
      `${new String(date.getDate()).padStart(2, '0')}/${new String(date.getMonth()+1).padStart(2, '0')}/${date.getFullYear()}`
    );
  }
}
