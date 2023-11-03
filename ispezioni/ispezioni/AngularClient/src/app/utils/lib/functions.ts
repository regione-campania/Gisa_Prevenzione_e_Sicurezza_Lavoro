import { SimpleChange } from "@angular/core";

//set intersection
export function intersect<T>(a: Set<T>, b: Set<T>) {
  const intersection = new Set<T>();
  for (let el of b) if (a.has(el)) intersection.add(el);
  return intersection;
}

//array intersection
export function intersectArray<T>(a: Array<T>, b: Array<T>) {
  const intersection = new Array<T>();
  for (let el of b) if (a.includes(el)) intersection.push(el);
  return intersection;
}

//returns a date ignoring its time
export function toDateWithoutTime(date: string | Date) {
  let temp = typeof date === 'string' ? new Date(date) : date;
  temp.setHours(0, 0, 0, 0);
  return temp;
}

//returns the logical (short-circuit) OR of a list of arguments
export function or(...args: any): any {
  if (args.length === 0) return undefined;
  let result = args[0];
  let i = 1;
  while (!result && i < args.length)
    result = args[i++];
  return result;
}

/**
 * Compare two values of the same type
 * @param a first value
 * @param b second value
 * @returns -1 (when a < b) | 1 (when a > b) | 0 (when a === b)
 */
export function compare<T>(a: T, b: T): number {
  return a < b ? -1 : a > b ? 1 : 0;
}

/**
 * Deep clone a 'serializable' object. Does not work with
 * export functions (with closures), Symbols, objects that represent HTML elements,
 * recursive data, and many other cases.
 * @param obj the 'serializable' object to be cloned
 * @returns a deep copy of the argument object
 */
export function deepCopy(obj: any) {
  return obj ? JSON.parse(JSON.stringify(obj)) : obj;
}

/**
 * Compare two values and returns true if they're deeply equals(i.e. if they are the
 * same value or if they have the same properties and those are equal, etc.)
 * @param a first value
 * @param b second value
 * @returns deep equality between a and b
 */
export function isDeeplyEqual(a: any, b: any) {
  if(typeof a !== typeof b)
    return false;
  if(!(a instanceof Object) && !(b instanceof Object))
    return a === b;
  if(Object.keys(a).length !== Object.keys(b).length)
    return false;
  for(let key in a) {
    if(!(key in b) || !isDeeplyEqual(a[key], b[key]))
      return false;
  }
  return true;
}

export function parseValue(value: any, type: string = 'text') {
  let parsed = value ?? '';
  switch (type) {
    case 'number':
      parsed = parseInt(parsed, 10);
      break;
    case 'date':
      parsed = new Date(parsed);
      parsed = parsed.toString() === 'Invalid Date' ? Date.now() : parsed;
      break;
    default:
      parsed = parsed.toLowerCase().trim();
      break;
  }
  return parsed;
}

/**
 * Stretches an element setting its height to fit the full window
 * @param element The element to strech
 * @param trimAmount Optional amount subtracted to element's height
 * @param additionalStyles optional styles to apply
 */

export function stretchToWindow(element: HTMLElement, trimAmount: string = '1px', additionalStyles?: Partial<CSSStyleDeclaration>, addListener = true): void {
  setTimeout(() => {
    let elementRect = element.getBoundingClientRect();
    element.style.height = `calc(${window.innerHeight - elementRect.top}px - ${trimAmount})`;
    //element.style.overflow = 'auto';
    if(additionalStyles) Object.assign(element.style, additionalStyles);
    if(addListener) {
      window.addEventListener('resize', function resizeHandler() {
        stretchToWindow(element, trimAmount, additionalStyles, false);
      });
    }
  })
}

/**
 * Stretches an element setting its height to fit the full window
 * @param element The element to strech
 * @param trimAmount Optional amount subtracted to element's height
 * @param additionalStyles optional styles to apply
 */

export function fitToWindow(element: HTMLElement, trimAmount: string = '0', additionalStyles?: Partial<CSSStyleDeclaration>, addListener = true): void {
  setTimeout(() => {
    let elementRect = element.getBoundingClientRect();
    element.style.minHeight = `calc(${window.innerHeight - elementRect.top}px - ${trimAmount})`;
    if(additionalStyles) Object.assign(element.style, additionalStyles);
    if(addListener) {
      window.addEventListener('resize', function resizeHandler() {
        stretchToWindow(element, trimAmount, additionalStyles, false);
      });
    }
  })
}

/**
 * Detect if there was a change in an Angular SimpleChange object.
 * @param change an Angular SimpleChange.
 * @returns **true** if a change occurred, **false** otherwise.
 */
export function isChanged(change: SimpleChange) {
  return change.currentValue !== change.previousValue;
}
