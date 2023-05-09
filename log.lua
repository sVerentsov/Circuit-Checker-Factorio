function LOG(str)
    if settings.global["circuit-checker-enable-logging"].value then
        log(str)
    end
end