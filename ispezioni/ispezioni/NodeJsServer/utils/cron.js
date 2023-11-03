const cron = require('node-cron');
const pagopa = require('../pagopa/pagopa');
const ispezioni = require('../routes/ispezioni');

const MIDNIGHT = "0 0 * * *";
const EVERY_MINUTE = "* * * * *";
const EVERY_5_MINUTES = "*/5 * * * *";
const EVERY_10_SECONDS = " */10 * * * * *";


initScheduledJobs = function() {
    const aggiornaAvvisiPagoPa = cron.schedule(MIDNIGHT, () => {
        pagopa.jobAggiornaStatoPagamenti();
        //pagopa.jobAnnullaPagamentiScadutiNonNotificati();
      });
    aggiornaAvvisiPagoPa.start();

    const aggiornaIspezioniProgrammate = cron.schedule(MIDNIGHT, () => {
      ispezioni.jobAggiornaStatoIspezioniProgrammate();
    });
    aggiornaIspezioniProgrammate.start();

    const jobAggiornaEsitoIspezioniChiuseConPagamento = cron.schedule(EVERY_10_SECONDS, () => {
      ispezioni.jobAggiornaEsitoIspezioniChiuseConPagamento();
    });
    jobAggiornaEsitoIspezioniChiuseConPagamento.start();

    console.log("CRON TASK AVVIATI");
}

exports.initScheduledJobs = initScheduledJobs;