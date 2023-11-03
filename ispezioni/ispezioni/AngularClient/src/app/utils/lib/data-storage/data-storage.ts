/**
 * A simple data storage
 */

export class DataStorage {
  private _data: { [key: string]: any } = {};

  getItem(key: string) {
    return this._data[key];
  }

  setItem(key: string, value: any) {
    this._data[key] = value;
  }
}
