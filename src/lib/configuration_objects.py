from core_data_modules.util import SHAUtils


class CodingModes(object):
    SINGLE = "SINGLE"
    MULTIPLE = "MULTIPLE"


class CodingConfiguration(object):
    def __init__(self, coding_mode, code_scheme, coded_field, fold_strategy, raw_field=None,
                 requires_manual_verification=True, analysis_file_key=None, cleaner=None,
                 include_in_theme_distribution=True):
        assert coding_mode in {CodingModes.SINGLE, CodingModes.MULTIPLE}

        self.coding_mode = coding_mode
        self.code_scheme = code_scheme
        self.coded_field = coded_field
        self.raw_field = raw_field
        self.requires_manual_verification = requires_manual_verification
        self.analysis_file_key = analysis_file_key
        self.fold_strategy = fold_strategy
        self.cleaner = cleaner
        self.include_in_theme_distribution = include_in_theme_distribution


class CodingPlan(object):
    def __init__(self, raw_field, coding_configurations, raw_field_fold_strategy, coda_filename=None, ws_code=None,
                 time_field=None, run_id_field=None, icr_filename=None, id_field=None, code_imputation_function=None,
                 message_id_fn=None):
        if message_id_fn is None:
            message_id_fn = lambda td: SHAUtils.sha_string(td[self.raw_field])

        self.raw_field = raw_field
        self.time_field = time_field
        self.run_id_field = run_id_field
        self.coda_filename = coda_filename
        self.icr_filename = icr_filename
        self.coding_configurations = coding_configurations
        self.code_imputation_function = code_imputation_function
        self.ws_code = ws_code
        self.raw_field_fold_strategy = raw_field_fold_strategy
        self.dataset_name = raw_field
        self.message_id_fn = message_id_fn

        if id_field is None:
            id_field = f"{self.raw_field}_id"
        self.id_field = id_field
