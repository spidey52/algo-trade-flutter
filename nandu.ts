let start = 1000 * 1000;

let incrementPercent = 0.3;

let numberOfDays = 365 * 9;

for (let i = 1; i <= numberOfDays; i++) {
 start = start * (1 + incrementPercent / 100);

 if (i % 365 === 0) {
  // render in indian number format

  let inNumberString = new Intl.NumberFormat("en-IN").format(start);

  console.log(`Year ${i / 365}: ${inNumberString}`);

  // let inNumberString = Intl.

  // console.log(`Year ${i / 365}: ${inNumberString}`);
 }
}
