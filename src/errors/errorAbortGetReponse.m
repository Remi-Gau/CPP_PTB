% (C) Copyright 2020 CPP_PTB developers

function errorAbortGetReponse

    errorStruct.message = 'Escape key press detected by getResponse: aborting experiment.';
    errorStruct.identifier = 'getResponse:abortRequested';

    error(errorStruct);
end
