function LOG(str)
    if settings.global["enable-logging"].value then
        log(str)
    end
end