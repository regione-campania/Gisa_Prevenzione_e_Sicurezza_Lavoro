import { ComparisonOperator, NumberFilterConf, NumberFilterMode } from '../..';
import { DataFilter } from './data-filter';

export class DataNumberFilter extends DataFilter {
  private _mode: NumberFilterMode = 'single';
  private _config: NumberFilterConf = {
    op: '=',
    value: 0,
  };

  condition = (value: string | number) => {
    let v = typeof value === 'string' ? +value : value;
    if(this.mode === 'range') {
      if ('lowerBound' in this.config)
        return this.config.lowerBound <= v && v <= this.config.upperBound;
    }
    else {
      if('op' in this.config)
        return this._evaluate(v, this.config.value, this.config.op);
    }
    //on error
    return false;
  };

  clean(): void {
    this._mode = 'single';
    this._config = {
      op: '=',
      value: 0,
    }
  }

  public get mode(): NumberFilterMode {
    return this._mode;
  }

  public set mode(value: NumberFilterMode) {
    this._mode = value;
    if (this._mode === 'single') {
      this._config = {
        op: '=',
        value: 0,
      };
    }
    else {
      this._config = {
        lowerBound: 0,
        upperBound: 100,
      }
    }
  }

  public get config(): NumberFilterConf {
    return this._config;
  }

  private set config(value: NumberFilterConf) {
    this._config = value;
  }

  private _evaluate(x: number, y: number, op: ComparisonOperator) {
    switch(op) {
      case '=': return x === y;
      case '!=': return x !== y;
      case '<' : return x < y;
      case '<=': return x <= y;
      case '>': return x > y;
      case '>=': return x >= y;
      default: return false;
    }
  }
}
